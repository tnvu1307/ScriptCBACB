SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE re0020 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                     IN       VARCHAR2,
   BRID                    IN       VARCHAR2,
   F_DATE                IN       VARCHAR2,
   T_DATE               IN       VARCHAR2,
   I_BRID                 IN       VARCHAR2,
   GROUPID            IN       VARCHAR2,
   RECUSTODYCD   IN       VARCHAR2,
   REROLE              IN       VARCHAR2,
   PVAFSTATUS       IN       VARCHAR2,
   TLID                   IN        VARCHAR2 default null
 )
IS
--bao cao gia tri giao dich truc tiep - nhom
--created by DieuNDA at 01/06/2015
--
--Modified by HoangNX on 12/06/2015: Thay doi cach lay phi giao dich thu them va phi giao dich hoan lai (lay theo tung khach hang)
   V_STROPTION      VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID        VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID         VARCHAR2 (5);

   VF_DATE          DATE;
   VT_DATE          DATE;
   V_GROUPID        VARCHAR2(10);
   V_STRCUSTODYCD   VARCHAR2(20);
   V_STRREROLE      VARCHAR2(20);
   v_TLID varchar2(4);
   v_TenMG varchar2(150);
   v_TenPhong varchar2(150);
   v_TenTP varchar2(150);
   v_currdate   date;
   v_AFSTATUS varchar2(5);
   v_BridPrm  VARCHAR2(5);
   v_maxhist DATE;
   v_prevwkfrdate date;
   v_nextwkfrdate date;
   v_nextwktrdate date;

BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;
   v_currdate := getcurrdate;
   --v_TLID:=TLID;

   if(V_STROPTION = 'A') then
        V_STRBRID := '%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := BRID;
        end if;
    end if;

   IF (upper(TLID) = 'ALL' or TLID is null)  THEN
    v_TLID := '%';
   ELSE
    v_TLID := UPPER(TLID);
   END IF;

   IF (UPPER(PVAFSTATUS) = 'ALL' OR PVAFSTATUS = 'DG' OR PVAFSTATUS IS NULL)  THEN
    v_AFSTATUS := '%';
   ELSE
    v_AFSTATUS := UPPER(PVAFSTATUS);
   END IF;

   IF (upper(GROUPID) = 'ALL' or GROUPID is null)  THEN
    V_GROUPID := '%';
    v_TenPhong:= 'ALL';
    v_TenTP:= 'ALL';
   ELSE
    V_GROUPID := UPPER(GROUPID);
    select gr.fullname, cf.fullname into v_TenPhong, v_TenTP
    from regrp gr, cfmast cf
    where gr.custid = cf.custid
        and SP_FORMAT_REGRP_MAPCODE(gr.autoid) = GROUPID
        and rownum<=1;
   END IF;

   IF (upper(RECUSTODYCD) = 'ALL' or RECUSTODYCD is null)  THEN
    V_STRCUSTODYCD := '%';
    v_TenMG:='ALL';
   ELSE
    V_STRCUSTODYCD := UPPER(RECUSTODYCD);
    select upper(fullname) into v_TenMG from cfmast where custid = RECUSTODYCD and rownum <= 1;
   END IF;

   IF (upper(REROLE) = 'ALL') or REROLE is null  THEN
    V_STRREROLE := '%';
   ELSE
    V_STRREROLE := REROLE;
   END IF;

   IF (upper(I_BRID) = 'ALL' or I_BRID is null)  THEN
    v_BridPrm := '%';
   ELSE
    v_BridPrm := UPPER(I_BRID);
   END IF;

   ------------------------
   VF_DATE := to_date(F_DATE,'DD/MM/RRRR');
   VT_DATE := to_date(T_DATE,'DD/MM/RRRR'); -- Fix truoc mot ngay lam viec

   v_prevwkfrdate := getprevworkingdate(VF_DATE);

   --v_nextwkfrdate :=/*getnextworkingdate(VF_DATE);*/ getnextworkingdate(v_prevwkfrdate);
   v_nextwkfrdate := getnextworkingdate(genworkingdate(VF_DATE));
   v_nextwktrdate := getnextworkingdate(VT_DATE);

   /*BEGIN
              IF VT_DATE < v_currdate THEN
                SELECT max(h.histdate) INTO v_maxhist
                FROM remast_hist h
                WHERE h.histdate BETWEEN VF_DATE AND VT_DATE;
              ELSE
                          v_maxhist := v_currdate;
              END IF;
              EXCEPTION WHEN OTHERS THEN v_maxhist := v_currdate;
   END;*/


OPEN PV_REFCURSOR FOR
      WITH MAIN AS
      (
       SELECT dtl.so_tk_kh, custid, custid_mg, so_tk_MG, ten_kh, ten_mg, afstatus, rerole, prerole, cust_kh, activedate, retype,
              tlname, brid, brname, BIEU_HH, ql_mg,
              execamt, feeacr, THUONG_HHDK, rnk,
              (CASE WHEN rnk = 1 THEN camt ELSE 0 END) camt,
              (CASE WHEN rnk = 1 THEN damt ELSE 0 END) damt,
              (CASE WHEN rnk = 1 THEN feeacr_com ELSE 0 END) feeacr_com,
              (CASE WHEN rnk = 1 THEN directfeeacr ELSE 0 END) directfeeacr,
              (CASE WHEN rnk = 1 THEN feeacr_com ELSE 0 END) + (CASE WHEN rnk = 1 THEN camt ELSE 0 END) - (CASE WHEN rnk = 1 THEN damt ELSE 0 END)
                        - (CASE WHEN rnk = 1 THEN directfeeacr2 ELSE 0 END) realfeeacr

         FROM
         (
          select cf.custid so_tk_kh,mst.custid, mst.custid custid_mg, mst.acctno so_tk_MG, cf.fullname ten_kh,
              cf2.fullname ten_mg, retype.afstatus, retype.rerole, allcode.cdcontent prerole, cf.custodycd cust_kh,
              cf.activedate activedate, retype.typename retype,
              nvl(rcf.tlname,'') tlname, nvl(rcf.brid,'') brid, nvl(rcf.brname,'') brname,
              sum(tl.amt) execamt, sum(tl.FREEAMT) feeacr,
              retype.typename /*|| ' _ ' || allcode.cdcontent*/ BIEU_HH, --Ngoc yeu cau chi hien thi ten bieu phi, ko hien thi vai tro them
              max(mst.recommision) THUONG_HHDK,
              substr(fn_getallbrokergrplnk(tl.reacctno,tl.txdate),-10,10) ql_mg,
              max(nvl(a.camt,0)) camt,
              max(nvl(a.damt,0)) damt,
              max(NVL(mst.directfeeacr, 0)) feeacr_com,
              max(nvl(drfeeretype,0)) directfeeacr,
              (max(nvl(mst.drfmatchamt,0)) + max(nvl( mst.drffeeacr,0))) directfeeacr2,
              SUM(NVL(tl.FREEAMT,0)) + max(nvl(a.camt,0)) - max(nvl(a.damt,0)) - max(nvl(com.directfeeacr,0)) realfeeacr,
              RANK() OVER (PARTITION BY mst.acctno ORDER BY sum(tl.FREEAMT) DESC, cf.custid) rnk
          from (
                     select reacctno, reactype, afacctno, txdate, sum(amt) amt, sum(freeamt) freeamt
                     from
                     (
                      select reacctno,reactype,afacctno,txdate,amt,freeamt
                      from reaf_log
                      where txdate BETWEEN VF_DATE and VT_DATE
                          UNION
                      select substr(re.reacctno,1,10) reacctno,substr(re.reacctno,11,4) reactype,/*af.acctno*/ af.custid afacctno,
                      v_currdate txdate,nvl(od.execamt,0) amt,nvl(od.feeacr,0) freeamt
                      from reaflnk re,afmast af,
                          (select afacctno,sum(execamt) execamt,sum(round(execamt * odt.deffeerate/100,2)) feeacr
                              from odmast od,odtype odt
                              where execamt > 0
                              and odt.actype=od.actype
                              and txdate=v_currdate
                              group by afacctno) od
                      where re.status='A'
                          and re.afacctno=af.custid
                          and v_currdate BETWEEN VF_DATE and VT_DATE
                          and re.frdate<=v_currdate and nvl(re.clstxdate,re.todate) > v_currdate
                          and od.afacctno(+)=af.acctno
                       )
                         group by reacctno, reactype, afacctno, txdate
              ) tl,
              --Tinh phi giam tru theo LHMG
              (
                  select commdate, custid, reactype, sum(directfeeacr) directfeeacr
                  from
                  (
                      (
                      select a.txdate commdate,a.recfcustid custid, a.actype reactype,
                      nvl(SUM( DECODE(RF.CALTYPE,'0001',RF.RERFRATE,0)* matchamt /100),0) + nvl(SUM( DECODE(RF.CALTYPE,'0002',RF.RERFRATE,0) *  feeOD /100),0) directfeeacr --  GIAM TRU doanh so + DOANH thu , t? theo phi lenh thuc te
                      from
                      (
                          select txdate,recfcustid,odfeetype,odfeerate, RCALLCENTER,VIA,matchamt,FEEACR,ACTYPE,sectype,feeOD,rerftype, caltype, tradeplace_vc tradeplace, min(stt) stt
                          from (
                              select vc.txdate,vc.recfcustid,vc.odfeetype,vc.odfeerate, vc.RCALLCENTER,vc.VIA,vc.matchamt,VC.FEEACR,VC.ACTYPE,vc.sectype,vc.tradeplace tradeplace_vc,vc.feeOD,
                                  rf.*, (CASE
                                           WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE <>'000' THEN 0
                                           WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE <>'000' THEN 1
                                           WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE ='000' THEN 2
                                           WHEN RF.SYMTYPE ='000' AND RF.TRADEPLACE ='000' THEN 3 END) STT
                              from
                                  (Select v_currdate txdate, /*re.recfcustid*/ mg.custid recfcustid, ret.RCALLCENTER,od.VIA,ret.actype,sb.sectype,sb.tradeplace, re.refrecflnkid, re.reacctno,
                                          sum(od.execamt) matchamt,
                                          sum(decode(rem.odfeetype,'F',od.execamt *rem.odfeerate/100,od.feeacr)) feeacr,
                                          max(rem.DAMTLASTDT) DAMTLASTDT,
                                          max(rem.odfeetype) odfeetype,
                                          max(rem.odfeerate) odfeerate,
                                          sum(od.feeacr) feeOD
                                  From reaflnk re, afmast af, vw_odmast_all od, recfdef red, retype ret, remast rem, sbsecurities sb, sysvar sys,  recflnk mg
                                  Where re.status='A' and re.deltd<>'Y'
                                      and re.frdate<= v_currdate and v_currdate < nvl(re.clstxdate,re.todate)
                                      and od.deltd<>'Y' and od.txdate = v_currdate and od.execamt >0
                                      and re.afacctno=af.custid and af.acctno=od.afacctno
                                      and re.refrecflnkid = red.refrecflnkid
                                      and substr(re.reacctno,11,4)=red.reactype
                                      and red.effdate<= v_currdate and  v_currdate < red.expdate
                                      and red.reactype=ret.actype
                                      and ret.retype='D'
                                      and re.reacctno=rem.acctno
                                      and sb.codeid=od.codeid
                                      --HoangNX them
                                       AND substr(re.reacctno,1,10) = mg.custid
                                      -----------
                                      AND rem.status = 'A'
                                      and ((ret.rdisposal = 'N') or (ret.rdisposal = 'Y' /*and   od.ISDISPOSAL = 'N'*/))  -- khong tinh doanh so lenh ban xu ly
                                      and (red.status<>'C' OR red.status IS NULL)
                                      --and sys.GRNAME = 'SYSTEM' AND sys.VARNAME ='CURRDATE'
                                      and v_currdate BETWEEN VF_DATE and VT_DATE
                                  Group by ret.actype, sb.sectype, sb.tradeplace, re.refrecflnkid, re.reacctno, /*re.recfcustid*/  mg.custid,ret.RCALLCENTER,od.VIA,v_currdate
                                  ) vc,rerfee rf
                              where rf.refobjid=VC.ACTYPE
                                 and (VC.TRADEPLACE=RF.TRADEPLACE OR RF.TRADEPLACE='000')
                                 AND (RF.SYMTYPE='000' OR
                                     (CASE
                                         WHEN vc.sectype='001' OR vc.sectype='002' OR vc.sectype='111' THEN 'EQT'
                                         WHEN vc.sectype='003' OR vc.sectype='006' OR vc.sectype='222' THEN 'DEB'
                                         WHEN vc.sectype='000' THEN '000' ELSE 'OTH' END) = RF.SYMTYPE
                                     )
                              )
                              group by txdate,recfcustid,odfeetype,odfeerate, RCALLCENTER,VIA,matchamt,FEEACR,ACTYPE,sectype,rerftype, caltype,feeOD, tradeplace_vc
                          ) a, Rerfee rf,ICCFTYPEDEF icc
                      where A.rerftype=rf.rerftype and A.caltype=rf.caltype
                          AND ICC.MODCODE='RE' AND ICC.EVENTCODE='CALFEECOMM' AND ICC.ICCFSTATUS='A' AND ICC.ACTYPE=RF.REFOBJID
                          and (a.TRADEPLACE=RF.TRADEPLACE OR RF.TRADEPLACE='000' )
                          AND (RF.SYMTYPE='000' OR
                              (CASE
                                  WHEN a.sectype='001' OR a.sectype='002' OR a.sectype='111' THEN 'EQT'
                                  WHEN a.sectype='003' OR a.sectype='006' OR a.sectype='222' THEN 'DEB'
                                  WHEN a.sectype='000' THEN '000' ELSE 'OTH' END) = RF.SYMTYPE
                              )
                          and rf.refobjid=a.actype
                          and (CASE
                                  WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE <>'000' THEN 0
                                  WHEN RF.SYMTYPE = '000' AND RF.TRADEPLACE <>'000' THEN 1
                                  WHEN RF.SYMTYPE <>'000' AND RF.TRADEPLACE ='000' THEN 2
                                  WHEN RF.SYMTYPE ='000' AND RF.TRADEPLACE ='000' THEN 3 END) = A.stt
                          AND a.SECTYPE not IN ('003','006')
                      group by a.txdate,a.recfcustid, a.actype
                      )
                          union all
                      (
                          select commdate, custid, reactype,
                                 SUM(nvl(rc.rfmatchamt,0)) + SUM(nvl(rc.rffeeacr,0)) + SUM(NVL(rc.drfeecallcenter, 0))
                                 + SUM(NVL(rc.drfeebondtypetp, 0)) + SUM(NVL(rc.feedisposal, 0))  directfeeacr
                          from recommision rc
                          where  commdate BETWEEN VF_DATE and VT_DATE
                          GROUP BY commdate, custid, reactype
                      )
                  )
                  where directfeeacr > 0
                  GROUP BY commdate, custid, reactype
              ) com,
              (
                  select substr(acctno,1,10) recustid, substr(acctno,11,4) reactype, sum(camt) camt, sum(damt) damt
                  from
                  (
                      select txdate,acctno,case when namt > 0 then namt else 0 end camt,case when namt < 0 then -namt else 0 end damt
                      from retran
                      where tltxcd='0312' and txdate BETWEEN VF_DATE and VT_DATE
                          union all
                      select txdate,acctno,case when namt > 0 then namt else 0 end camt,case when namt < 0 then -namt else 0 end damt
                      from retrana
                      where tltxcd='0312' and txdate BETWEEN VF_DATE and VT_DATE
                  )
                  group by substr(acctno,1,10), substr(acctno,11,4)

                  /*SELECT tlg.busdate txdate, tlg.cfcustodycd, SUM(tlf.adjvalue) camt
                  FROM vw_tllog_all_re tlg,
                  (
                  SELECT  txnum, txdate, MAX((CASE WHEN fldcd = '09' THEN cvalue END) ) TxType, max(CASE WHEN fldcd = '10' THEN nvalue END ) AdjValue
                                FROM vw_tllogfld_re
                                WHERE (fldcd = '09' OR fldcd = '10')
                                AND txdate BETWEEN VF_DATE and VT_DATE
                  GROUP BY txnum, txdate
                  HAVING MAX((CASE WHEN fldcd = '09' THEN cvalue END) )  = '033' --Loai: Thu them phi giao dich
                  ) tlf
                  WHERE tlg.txnum = tlf.txnum
                        AND tlg.txdate = tlf.txdate
                        AND tlg.tltxcd = '1190'
                        AND tlg.busdate BETWEEN VF_DATE and VT_DATE
                  GROUP BY tlg.busdate, tlg.cfcustodycd*/
              ) a,
              /*(
              SELECT ci.custodycd, SUM(ci.namt) damt
              FROM vw_citran_gen ci
              WHERE ci.tltxcd = '1138'
                    AND ci.txcd = '0012'
                    AND ci.busdate BETWEEN VF_DATE and VT_DATE
              GROUP BY ci.custodycd
              ) ci,*/
               (SELECT h.custid, h.acctno, h.actype, SUM(h.dfeeacr) directfeeacr,sum(nvl(drfmatchamt,0)) drfmatchamt, --giam tru doanh so
                       SUM(h.recommision) recommision,  sum(nvl(drffeeacr,0))   drffeeacr, -- giam tru doanh thu
                       SUM(nvl(h.drfeecallcenter,0)) + SUM(nvl(drfeebondtypetp,0)) + SUM(nvl(dfeedisposal,0)) + sum(nvl(drfmatchamt,0))  + sum(nvl(drffeeacr,0)) drfeeretype
                 FROM
                    (/*SELECT v_currdate histdate, acctno, custid, actype, status, pstatus, last_change, ratecomm, balance, damtacr, damtlastdt, iamtacr,
                                iamtlastdt, directacr, indirectacr, odfeetype, odfeerate, commtype, lastcommdate, dfeeacr, ifeeacr, directfeeacr,
                                indirectfeeacr, rfmatchamt, rffeeacr, drfmatchamt, drffeeacr, inrfmatchamt, inrffeeacr, dlmn, ddisposal, lmn,
                                disposal, inlmn, indisposal, recommision, drcallcenter, rcallcenter, drfeecallcenter, rfeecallcenter, drffeecomm,
                                rffeecomm, inrffeecomm, drbondtypetp, rbondtypetp, drfeebondtypetp, rfeebondtypetp, feedisposal, dfeedisposal, ifeedisposal
                     FROM remast
                     where VF_DATE = v_currdate AND VT_DATE = v_currdate
                     UNION
                     SELECT histdate, acctno, custid, actype, status, pstatus, last_change, ratecomm, balance, damtacr, damtlastdt, iamtacr,
                                 iamtlastdt, directacr, indirectacr, odfeetype, odfeerate, commtype, lastcommdate, dfeeacr, ifeeacr, directfeeacr,
                                indirectfeeacr, rfmatchamt, rffeeacr, drfmatchamt, drffeeacr, inrfmatchamt, inrffeeacr, dlmn, ddisposal, lmn,
                                disposal, inlmn, indisposal, recommision, drcallcenter, rcallcenter, drfeecallcenter, rfeecallcenter, drffeecomm,
                                rffeecomm, inrffeecomm, drbondtypetp, rbondtypetp, drfeebondtypetp, rfeebondtypetp, feedisposal, dfeedisposal, ifeedisposal
                      FROM remast_hist WHERE (histdate > v_nextwkfrdate and histdate <= v_nextwktrdate) or (histdate = v_nextwkfrdate and v_nextwkfrdate = v_nextwktrdate)

                      UNION all

                      SELECT (v_currdate-1) histdate, acctno, custid, actype, status, pstatus, last_change, ratecomm, balance, damtacr, damtlastdt, iamtacr,
                                iamtlastdt, directacr, indirectacr, odfeetype, odfeerate, commtype, lastcommdate, dfeeacr, ifeeacr, directfeeacr,
                                indirectfeeacr, rfmatchamt, rffeeacr, drfmatchamt, drffeeacr, inrfmatchamt, inrffeeacr, dlmn, ddisposal, lmn,
                                disposal, inlmn, indisposal, recommision, drcallcenter, rcallcenter, drfeecallcenter, rfeecallcenter, drffeecomm,
                                rffeecomm, inrffeecomm, drbondtypetp, rbondtypetp, drfeebondtypetp, rfeebondtypetp, feedisposal, dfeedisposal, ifeedisposal
                     FROM remast
                     where (VT_DATE >= v_currdate-1 AND VF_DATE <> VT_DATE)*/

                     SELECT v_currdate histdate, acctno, custid, actype, status, pstatus, last_change, ratecomm, balance, damtacr, damtlastdt, iamtacr,
                                iamtlastdt, directacr, indirectacr, odfeetype, odfeerate, commtype, lastcommdate, dfeeacr, ifeeacr, directfeeacr,
                                indirectfeeacr, rfmatchamt, rffeeacr, drfmatchamt, drffeeacr, inrfmatchamt, inrffeeacr, dlmn, ddisposal, lmn,
                                disposal, inlmn, indisposal, recommision, drcallcenter, rcallcenter, drfeecallcenter, rfeecallcenter, drffeecomm,
                                rffeecomm, inrffeecomm, drbondtypetp, rbondtypetp, drfeebondtypetp, rfeebondtypetp, feedisposal, dfeedisposal, ifeedisposal
                     FROM remast
                     where (v_currdate >= v_nextwkfrdate and v_currdate <= v_nextwktrdate) or (VF_DATE = v_currdate AND VT_DATE = v_currdate)
                     union all
                     SELECT histdate, acctno, custid, actype, status, pstatus, last_change, ratecomm, balance, damtacr, damtlastdt, iamtacr,
                                 iamtlastdt, directacr, indirectacr, odfeetype, odfeerate, commtype, lastcommdate, dfeeacr, ifeeacr, directfeeacr,
                                indirectfeeacr, rfmatchamt, rffeeacr, drfmatchamt, drffeeacr, inrfmatchamt, inrffeeacr, dlmn, ddisposal, lmn,
                                disposal, inlmn, indisposal, recommision, drcallcenter, rcallcenter, drfeecallcenter, rfeecallcenter, drffeecomm,
                                rffeecomm, inrffeecomm, drbondtypetp, rbondtypetp, drfeebondtypetp, rfeebondtypetp, feedisposal, dfeedisposal, ifeedisposal
                      FROM remast_hist h
                      where h.histdate >= v_nextwkfrdate and histdate <= v_nextwktrdate
                      ) h

              GROUP BY h.custid, h.acctno, h.actype) mst,
              cfmast cf, cfmast cf2,
              retype, allcode,
              (
                  select rcf.custid, rcf.tlid, rcf.brid , nvl(tl.tlname,'') tlname, nvl(br.brname,'') brname
                  from recflnk rcf, tlprofiles tl, brgrp br
                  where rcf.tlid=tl.tlid(+)
                   and rcf.brid=br.brid
                   --AND rcf.status = 'A'
                   --and effdate<=VT_DATE and expdate>VT_DATE
                   --and effdate<=VT_DATE
                   --and expdate>VF_DATE
                   --Check chuyen User
                   AND (rcf.status = 'A' OR (rcf.status = 'C'
                             AND NOT EXISTS (SELECT t1.custid FROM recflnk t1 WHERE t1.custid = rcf.custid GROUP BY t1.custid HAVING COUNT(t1.tlid) > 1)))
              ) rcf
          where tl.reacctno = mst.custid(+)
              and tl.reactype = mst.actype(+)
              and tl.afacctno = cf.custid
              and mst.custid = cf2.custid
              and mst.actype = retype.actype
              and allcode.cdtype = 'RE' and allcode.cdname = 'REROLE' and allcode.cdval = retype.rerole

              and tl.reacctno=a.recustid(+)
              AND tl.reactype = a.reactype(+)
              --------------------------------------------
              --AND cf.custodycd = a.cfcustodycd(+)
              --AND cf.custodycd = ci.custodycd(+)
              -------------------------------------
              and tl.reacctno=com.custid(+)
              AND tl.reactype = com.reactype(+)
              and to_char(tl.txdate, 'YYYY-MM') = to_char(add_months(com.commdate(+), -1), 'YYYY-MM')
              --AND tl.txdate =com.commdate(+)

              and tl.reacctno=rcf.custid(+)
              --and rcf.effdate<=VT_DATE and rcf.expdate>VT_DATE
              AND retype.rerole LIKE V_STRREROLE
              and retype.afstatus like v_AFSTATUS
              --Check careby
              and exists (select gu.grpid from tlgrpusers gu where cf.careby = gu.grpid and gu.tlid like v_TLID )
              AND rcf.brid LIKE V_STRBRID
              AND rcf.brid LIKE v_BridPrm
              --
              and case when tl.reacctno like V_STRCUSTODYCD then 1 else instr(fn_getallbrokergrplnk(tl.reacctno,tl.txdate),V_STRCUSTODYCD) end > 0
              --and VF_DATE <= tl.txdate
              --AND VT_DATE >= tl.txdate
          group by cf.custid ,mst.custid, mst.acctno , cf.fullname ,
              cf2.fullname , retype.afstatus, retype.rerole, allcode.cdcontent,retype.afstatus, cf.custodycd ,
              cf.activedate , retype.typename ,
              retype.typename || ' _ ' || allcode.cdcontent,
              substr(fn_getallbrokergrplnk(tl.reacctno,tl.txdate),-10,10),
              nvl(rcf.tlname,'') , nvl(rcf.brid,'') , nvl(rcf.brname,'')
         )  dtl
      )

    --Output
    SELECT IN_GROUPID, IN_RECUSTODYCD, IN_REROLE, TU_NGAY, DEN_NGAY, i_TenMG, i_TenPhong, i_TenTP,
           so_tk_kh, custid, so_tk_MG, ten_kh, ten_mg, rerole, prerole, afstatus, pafstatus, cust_kh, custid_mg, retype,
           BIEU_HH, ql_mg, tlname, brid, brname, ten_truong_nhom, ten_nhom, ma_nhom, autoid,
           execamt, feeacr, camt, damt, directfeeacr, realfeeacr,
           (CASE WHEN rnk2 = 1 THEN thuong_mg ELSE 0 END) thuong_mg,
           (CASE WHEN rnk2 = 1 THEN thuong_nhom ELSE 0 END) thuong_nhom
    FROM
    (
    SELECT  GROUPID IN_GROUPID, RECUSTODYCD IN_RECUSTODYCD, REROLE IN_REROLE,to_char(VF_DATE,'DD/MM/RRRR') TU_NGAY,
        to_char(VT_DATE,'DD/MM/RRRR') DEN_NGAY, v_TenMG i_TenMG, v_TenPhong i_TenPhong, v_TenTP i_TenTP,
        main.so_tk_kh, main.custid, main.so_tk_MG,
        main.ten_kh, main.ten_mg, main.rerole,/*main.prerole*/ reg.roletype prerole, main.afstatus, a0.cdcontent pafstatus,
        main.cust_kh, main.custid_mg, main.retype, main.BIEU_HH,main.ql_mg,
        main.tlname, main.brid, main.brname,
        SUM(main.execamt) execamt, SUM(main.feeacr) feeacr,
        SUM(main.camt) camt, SUM(main.damt) damt, SUM(main.directfeeacr) directfeeacr,
        SUM(main.realfeeacr) realfeeacr,
        MAX(TMG.THUONG)thuong_mg,
        reg.ten_truong_nhom, reg.ten_nhom /*|| '_' || reg.ten_truong_nhom*/ ten_nhom,
        reg.autoid ma_nhom, NVL(reg.autoid,0) autoid,
        MAX(TMG.THUONG) thuong_nhom,
        RANK() OVER (PARTITION BY main.so_tk_MG ORDER BY SUM(main.feeacr) DESC, main.so_tk_kh) rnk2

    FROM
        MAIN
        LEFT JOIN -- left join
        (
        SELECT cfmast.fullname ten_truong_nhom, tn.fullname ten_nhom, nhom.CUSTID, SP_FORMAT_REGRP_MAPCODE(tn.autoid) AUTOID,nhom.CUSTID reacctno, roletype
            FROM (
                    select DISTINCT refrecflnkid AUTOID,REACCTNO CUSTID, ac.cdcontent roletype
                    from regrplnk lnk, regrp gr, allcode ac
                    where gr.autoid = lnk.refrecflnkid
                        AND ac.cdval = gr.grptype
                        AND ac.cdtype = 'RE'
                        AND ac.cdname = 'ROLETYPE'
                        AND lnk.status='A'
                        --and case when lnk.REACCTNO like V_STRCUSTODYCD then 1 else instr(fn_getallbrokergrplnk(lnk.custid,VT_DATE),V_STRCUSTODYCD) end > 0
                    GROUP BY lnk.refrecflnkid,lnk.REACCTNO, ac.cdcontent
                    UNION
                    SELECT  AUTOID,CUSTID||ACTYPE CUSTID, ac.cdcontent roletype
                    FROM REGRP gr, allcode ac
                    WHERE  ac.cdval = gr.grptype
                        AND ac.cdtype = 'RE'
                        AND ac.cdname = 'ROLETYPE'
                        AND gr.STATUS='A'
                        AND gr.CUSTID like V_STRCUSTODYCD
                ) nhom, regrp tn, cfmast
            WHERE tn.autoid = nhom.autoid
                AND tn.custid = cfmast.custid
                group by cfmast.fullname,tn.fullname,tn.autoid,nhom.CUSTID, roletype
        ) reg
        ON MAIN.so_tk_MG = reg.CUSTID
        ,(
            select main.so_tk_MG ,
                fn_re_icrate(main.so_tk_MG,sum(main.realfeeacr),sum(main.execamt))/100 *suM(main.realfeeacr) thuong
            from main
            group by main.so_tk_MG
        )tmg, allcode a0
    where main.so_tk_MG=tmg.so_tk_MG
        and a0.cdtype = 'RE' and a0.cdname = 'AFSTATUS' and a0.cdval=main.afstatus
    GROUP BY main.so_tk_kh, main.custid, main.so_tk_MG,main.tlname, main.brid, main.brname,
        main.ten_kh, main.ten_mg, main.rerole, /*main.prerole*/ roletype,main.afstatus,a0.cdcontent,
        main.cust_kh, main.custid_mg, main.retype, main.BIEU_HH, reg.ten_truong_nhom, reg.ten_nhom, reg.reacctno, reg.AUTOID,main.ql_mg
    having sum(main.execamt)>0
    )
    WHERE autoid LIKE V_GROUPID
          AND brid LIKE v_BridPrm
    ;
    EXCEPTION
       WHEN OTHERS
       THEN
          RETURN;
End;
/
