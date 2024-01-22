SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE RE0024 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                IN       VARCHAR2,
   BRID               IN       VARCHAR2,
   F_DATE           IN       VARCHAR2,
   T_DATE           IN       VARCHAR2,
   I_BRID            IN       VARCHAR2,
   TLNAME         IN       VARCHAR2,
   TLID               IN       VARCHAR2
 )
IS
--Bao cao doanh thu chi tiet theo moi gioi
--Created by HoangNX
--Created date 15/06/2015

   V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID      VARCHAR2 (40);            -- USED WHEN V_NUMOPTION > 0
   V_INBRID     VARCHAR2 (5);

   v_FromDate DATE;
   v_ToDate DATE;
   v_Tlname VARCHAR2(10);
   v_TLID   VARCHAR2(10);
   v_BridPrm  VARCHAR2(5);

BEGIN

   V_STROPTION := upper(OPT);
   V_INBRID := BRID;

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

   -----------------------
   IF (UPPER(TLNAME) = 'ALL' OR TLNAME IS NULL) THEN
        v_Tlname := '%';
   ELSE
        v_Tlname := UPPER(TLNAME);
   END IF;

   IF (upper(I_BRID) = 'ALL' or I_BRID is null)  THEN
    v_BridPrm := '%';
   ELSE
    v_BridPrm := UPPER(I_BRID);
   END IF;

   v_FromDate := to_date(F_DATE,'DD/MM/RRRR');
   v_ToDate := to_date(T_DATE,'DD/MM/RRRR');


OPEN PV_REFCURSOR FOR
select * from dual;
/*     WITH dtl AS
     --Moi gioi cham soc khach hang
      (
      select tl.brid, br.brname, tl.tlname, tl.tlfullname, kh.custid, kh.custodycd, kh.fullname, af.frdate, af.todate,
        nvl(af.clstxdate, af.todate) clstxdate, cf.effdate cfeffdate, cf.expdate cfexpdate --01/07/2015 DieuNDA: them ngay hieu luc of recflnk
      from reaflnk af,recflnk cf, cfmast kh, tlprofiles tl, brgrp br
      WHERE substr(af.reacctno,1,10) = cf.custid
          AND af.refrecflnkid = cf.autoid
          and cf.tlid = tl.tlid
          and af.afacctno = kh.custid
          AND tl.brid = br.brid
          AND NVL(af.clstxdate, af.todate) > af.frdate
          AND af.frdate <=  v_ToDate
          AND kh.opndate <= v_ToDate
          --AND CF.effdate <= v_ToDate
          --AND cf.expdate>=v_FromDate --check ngay hieu luc cua recflnk
          AND NVL(af.clstxdate, af.todate) >= v_FromDate --Chi xet trong khoang thoi gian tao bao cao (het han sau tu ngay)
          AND tl.tlname LIKE v_TLNAME
          AND br.brid LIKE v_BridPrm
          --Check careby
          AND EXISTS (select gu.grpid from tlgrpusers gu, afmast afm where gu.tlid LIKE v_TLID AND afm.careby =gu.grpid AND afm.custid = kh.custid)
      )

   SELECT od2.brid, od2.brname, od2.tlname, od2.tlfullname,
          SUM(MatchedValue) MatchedValue,
          SUM(fee) + SUM(fee_add) - SUM(fee_revert) TradingFee,
          SUM(loan_acr) loan_acr,
          SUM(loan_curr) loan_curr,
          SUM(loanintfee_curr) loanintfee_curr,
          SUM(IntFeeRevenue) + SUM(intrev_add) - SUM(intrev_revert) int_revenue,
          SUM(pia_fee) + SUM(pia_add)- SUM(pia_revert) pia_revenue,
          SUM(IntCurr_DF) + SUM(IntRevenue_DF) + SUM(ext_fee) + SUM(feerenew_add) - SUM(feerenew_revert) ext_revenue
   FROM
                (SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname,
                        SUM(CASE WHEN dtl.frdate <= od.txdate AND dtl.clstxdate > od.txdate /*and dtl.cfeffdate <= od.txdate and dtl.cfexpdate > od.txdate*/ --check them dk ngay hieu luc cua recflnk
/*                                THEN nvl(od.MatchedValue,0) ELSE 0 END) MatchedValue,
                        SUM(CASE WHEN dtl.frdate <= od.txdate AND dtl.clstxdate > od.txdate /*and dtl.cfeffdate <= od.txdate and dtl.cfexpdate > od.txdate*/ --check them dk ngay hieu luc cua recflnk
/*                                THEN NVL(od.Fee,0) ELSE 0 END) fee
               FROM dtl,
                        --Phi giao dich: Lay theo ngay de co the xac dinh trong khoang thoi gian do khach hang do moi gioi nao cham soc
                        (SELECT cfc.custodycd, od.txdate, sum(od.execamt) MatchedValue,
                        sum(NVL(DECODE(OD.feeamt, 0,DECODE(OD.FEEACR,0,OD.EXECAMT * ODT.DEFFEERATE / 100,OD.FEEACR)),OD.FEEACR))  Fee
                        FROM vw_odmast_all od, afmast afc, cfmast cfc, odtype odt
                        WHERE od.afacctno = afc.acctno
                              AND afc.custid = cfc.custid
                              AND od.actype = odt.actype
                              AND od.deltd <> 'Y'
                             AND od.txdate BETWEEN v_FromDate AND v_ToDate
                        GROUP BY cfc.custodycd, od.txdate
                        ) od
                WHERE dtl.custodycd = od.custodycd(+)
                GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname
                ) od2,

                (SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname,
                        SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate and dtl.cfeffdate <= fee.txdate and dtl.cfexpdate > fee.txdate --check them dk ngay hieu luc cua recflnk
                                    THEN NVL(fee.fee_add,0) ELSE 0 END) fee_add,
                        SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate and dtl.cfeffdate <= fee.txdate and dtl.cfexpdate > fee.txdate --check them dk ngay hieu luc cua recflnk
                                    THEN NVL(fee.intrev_add,0) ELSE 0 END) intrev_add,
                        SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate and dtl.cfeffdate <= fee.txdate and dtl.cfexpdate > fee.txdate --check them dk ngay hieu luc cua recflnk
                                    THEN NVL(fee.intrev_revert,0) ELSE 0 END) intrev_revert,
                        SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate and dtl.cfeffdate <= fee.txdate and dtl.cfexpdate > fee.txdate --check them dk ngay hieu luc cua recflnk
                                    THEN NVL(fee.pia_add,0) ELSE 0 END) pia_add,
                        SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate and dtl.cfeffdate <= fee.txdate and dtl.cfexpdate > fee.txdate --check them dk ngay hieu luc cua recflnk
                                    THEN NVL(fee.pia_revert,0) ELSE 0 END) pia_revert,
                        SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate and dtl.cfeffdate <= fee.txdate and dtl.cfexpdate > fee.txdate --check them dk ngay hieu luc cua recflnk
                                    THEN NVL(fee.feerenew_revert,0) ELSE 0 END) feerenew_revert,
                        SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate and dtl.cfeffdate <= fee.txdate and dtl.cfexpdate > fee.txdate --check them dk ngay hieu luc cua recflnk
                                    THEN NVL(fee.feerenew_add,0) ELSE 0 END) feerenew_add
                FROM dtl,
                          --Phi thu them: Tra phi mua/Tra phi ban, phi gia han...............
                           (
                          SELECT tlg.busdate txdate, tlg.cfcustodycd,
                          SUM (CASE WHEN tlg.tltxcd = '1190' AND tlf.txtype IN ('002', '003') THEN tlf.adjvalue ELSE 0 END) fee_add,
                          SUM (CASE WHEN tlg.tltxcd = '1190' AND tlf.txtype IN ('040', '041', '042') THEN tlf.adjvalue ELSE 0 END) intrev_add,
                          SUM (CASE WHEN tlg.tltxcd = '1191' AND tlf.txtype IN ('020', '021', '022') THEN tlf.adjvalue ELSE 0 END) intrev_revert,
                          SUM(CASE WHEN tlg.tltxcd = '1190' AND tlf.txtype IN ('034', '035') THEN tlf.adjvalue ELSE 0 END) pia_add,
                          SUM (CASE WHEN tlg.tltxcd = '1191' AND tlf.txtype IN ('014', '015') THEN tlf.adjvalue ELSE 0 END) pia_revert,
                          SUM(CASE WHEN tlg.tltxcd = '1191' AND tlf.txtype IN ('023') THEN tlf.adjvalue ELSE 0 END) feerenew_revert,
                          SUM(CASE WHEN tlg.tltxcd = '1190' AND tlf.txtype IN ('043') THEN tlf.adjvalue ELSE 0 END) feerenew_add
                          FROM vw_tllog_all_re tlg,
                          (
                          SELECT  txnum, txdate, MAX((CASE WHEN fldcd = '09' THEN cvalue END) ) TxType, max(CASE WHEN fldcd = '10' THEN nvalue END ) AdjValue
                                        FROM vw_tllogfld_re
                                        WHERE (fldcd = '09' OR fldcd = '10')
                                         AND txdate BETWEEN v_FromDate AND v_ToDate
                          GROUP BY txnum, txdate
                          HAVING MAX((CASE WHEN fldcd = '09' THEN cvalue END) )  IN ('002', '003', '040', '041', '042', '020', '021', '022', '034', '035', '014', '015', '023', '043') --Loai: Tra phi mua/Tra phi ban
                          ) tlf
                          WHERE tlg.txnum = tlf.txnum
                                AND tlg.txdate = tlf.txdate
                                AND tlg.tltxcd IN ('1190', '1191')
                                AND tlg.busdate BETWEEN v_FromDate AND v_ToDate
                          GROUP BY tlg.busdate, tlg.cfcustodycd
                          ) fee
                WHERE dtl.custodycd = fee.cfcustodycd(+)
                GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname
                ) fee2,

                (SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname,
                            SUM(CASE WHEN dtl.frdate <= ci_fee.txdate AND dtl.clstxdate > ci_fee.txdate and dtl.cfeffdate <= ci_fee.txdate and dtl.cfexpdate > ci_fee.txdate --check them dk ngay hieu luc cua recflnk
                                        THEN NVL(ci_fee.fee_revert,0) ELSE 0END) fee_revert
                FROM dtl,
                        --Phi hoan lai
                        (
                        SELECT ci.custodycd, ci.busdate txdate, 0 fee_revert --SUM(ci.namt) fee_revert khong tinh phi 1138
                        FROM vw_citran_gen ci
                        WHERE ci.tltxcd = '1138'
                              AND ci.txcd = '0012'
                              AND ci.busdate BETWEEN v_FromDate AND v_ToDate
                        GROUP BY ci.custodycd, ci.busdate
                        ) ci_fee
                WHERE dtl.custodycd = ci_fee.custodycd(+)
                GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname
                ) ci_fee2/*,

                (SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname,
                            --Du no cong don: tinh cho moi gioi theo ngay giai ngan, ngay giai ngan phai thuoc thoi gian xem bao cao
                            SUM(CASE WHEN lna.rlsdate >= dtl.frdate AND lna.rlsdate < dtl.clstxdate and dtl.cfeffdate <= lna.rlsdate and dtl.cfexpdate > lna.rlsdate --check them dk ngay hieu luc cua recflnk
                                    AND lna.rlsdate BETWEEN v_FromDate AND v_ToDate THEN NVL(lna.F_GTGN, 0) ELSE 0 END) loan_acr,
                              --Du no hien tai tinh cho moi gioi cuoi cung: ngay giai ngan khong quan tam, chi can nho hon Den Ngay
                            SUM(CASE WHEN v_ToDate < dtl.clstxdate THEN NVL(lna.F_DNHT, 0) ELSE 0 END) loan_curr,
                            SUM(CASE WHEN v_ToDate < dtl.clstxdate THEN NVL(lna.F_LAI, 0) + NVL(lna.F_PHI, 0) ELSE 0 END) loanintfee_curr,
                            SUM(CASE WHEN v_ToDate < dtl.clstxdate THEN NVL(lna.IntCurr_DF, 0) ELSE 0 END) IntCurr_DF
                FROM dtl,
                        --Du no
                        (
                        SELECT CF.CUSTODYCD, ls.rlsdate,
                               SUM(CASE WHEN ln.ftype = 'DF' AND lnt.loantype = 'DF' THEN
                                       round(LS.INTNMLACR,6)+round(LS.INTDUE,6)+round(LS.INTOVD,6)+round(LS.INTOVDPRIN,6)  - round(NVL(LNTR.INT_MOVE,0),6)
                                       + round(LS.FEEINTNMLACR,6) + round(LS.FEEINTOVDACR,6) + round(LS.FEEINTNMLOVD,6) + round(LS.FEEINTDUE,6) - round(NVL(LNTR.PRFEE_MOVE,0),6)
                                      ELSE 0
                                      END) IntCurr_DF,
                               sum(round(LS.NML)+round(LS.OVD)+round(LS.PAID)) F_GTGN,
                               SUM( round(LS.PAID) - round(NVL(LNTR.PRIN_MOVE,0))) F_GTTL,
                               sum(round(LS.NML)+round(LS.OVD)  - round( NVL(LNTR.PRIN_MOVE,0)))  F_DNHT,
                               SUM(CASE WHEN ln.ftype <> 'DF' THEN
                                      (round(LS.INTNMLACR)+round(LS.INTDUE)+round(LS.INTOVD)+round(LS.INTOVDPRIN)  - round(NVL(LNTR.INT_MOVE,0)))
                                      ELSE 0
                                      END) F_LAI,
                             SUM(CASE WHEN ln.ftype <> 'DF' THEN
                                      (round(LS.FEEINTNMLACR) + round(LS.FEEINTOVDACR) + round(LS.FEEINTNMLOVD) + round(LS.FEEINTDUE) -- +  LS.INTPAID + LS.FEEINTPAID
                                      - round(NVL(LNTR.PRFEE_MOVE,0)))
                                       ELSE 0
                                      END) F_PHI
                        FROM vw_lnmast_all LN, vw_lnschd_all ls,
                                   (SELECT AUTOID,SUM((CASE WHEN NML > 0 THEN 0 ELSE NML END)
                                                        +OVD) PRIN_MOVE,
                                    SUM(round(INTNMLACR) +round(INTDUE)+round(INTOVD)+round(INTOVDPRIN)) INT_MOVE,
                                    SUM(round(FEEINTNMLACR)+ round(FEEINTDUE)+round(FEEINTOVD)+round(FEEINTOVDPRIN)) PRFEE_MOVE
                                    FROM vw_lnschdlog_all LNSLOG
                                    WHERE NVL(DELTD,'N') <>'Y' AND TXDATE > v_ToDate
                                    GROUP BY AUTOID) LNTR,
                              CFMAST CF, AFMAST AF,  CFMAST CFB --, LNTYPE LNT
                        WHERE LN.ACCTNO = LS.ACCTNO
                        AND LS.REFTYPE IN ('P','GP')
                        AND LN.ACTYPE = LNT.actype
                        AND LS.RLSDATE  <= v_ToDate
                        AND LS.AUTOID = LNTR.AUTOID(+)
                        AND lN.custbank = cfb.custid(+)
                        --CHECK TRANG THAI TAT TOAN
                        --AND LS.NML+LS.OVD - NVL(LNTR.PRIN_MOVE,0)+LS.INTNMLACR+LS.INTDUE+LS.INTOVD+LS.INTOVDPRIN  - NVL(LNTR.INT_MOVE,0)+  LS.FEEINTNMLACR + LS.FEEINTOVDACR + LS.FEEINTNMLOVD + LS.FEEINTDUE -- +  LS.INTPAID + LS.FEEINTPAID
                                   --- NVL(LNTR.PRFEE_MOVE,0)> 0
                        AND CF.CUSTID = AF.CUSTID
                        AND LN.TRFACCTNO = AF.ACCTNO
                        --AND ln.ftype <> 'DF' --Khong lay du no cam co
                        --AND  (AF.BRID LIKE V_STRBRID OR INSTR(V_STRBRID,AF.BRID) <> 0)
                      -- and exists (select gu.grpid from tlgrpusers gu where gu.tlid = V_STRTLID AND af.careby =gu.grpid)
                        GROUP BY  CF.CUSTODYCD, ls.rlsdate
                        ) lna
                WHERE dtl.custodycd = lna.custodycd(+)
                GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname
                ) lna2,

                (SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, 0 IntFeeRevenue
                            --Doanh thu lai, phi: Lai, phi da tra
                           -- SUM(CASE WHEN lnp.paiddate >= dtl.frdate AND lnp.paiddate < dtl.clstxdate and dtl.cfeffdate <= lnp.paiddate and dtl.cfexpdate > lnp.paiddate --check them dk ngay hieu luc cua recflnk
                            --            THEN NVL(lnp.IntFeeRevenue, 0) ELSE 0 END) IntFeeRevenue
                FROM dtl/*,
                          --Lai phi da tra, lay theo ngay tra, neu ngay tra ma khach hang thuoc moi gioi nao thi tinh cho moi gioi do
                          (
                          SELECT cf.custodycd, lt.TXDATE paiddate, SUM(nvl(lt.NAMT,0)) IntFeeRevenue
                          FROM vw_lntran_all lt, apptx TX, vw_lnmast_all mst, vw_lnschd_all lns, afmast af, cfmast cf
                          WHERE lt.TXCD = tx.txcd
                                AND tx.Field IN ('INTPAID', 'OINTPAID')
                                AND tx.Apptype = 'LN'
                                AND mst.acctno = lns.acctno
                                AND lns.AUTOID = lt.REF
                                AND mst.TRFACCTNO = af.acctno
                                AND mst.ftype <> 'DF' --Khong lay du no cam co
                                AND af.custid = cf.custid
                                AND lt.TXDATE  BETWEEN v_FromDate AND V_ToDate
                          GROUP BY cf.custodycd, lt.TXDATE
                         --REF la ma lich vay trong lnschd
                          ) lnp
               WHERE dtl.custodycd = lnp.custodycd(+)
               GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname*/
               --) lnp2,

               /*(SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, 0 IntRevenue_DF
                            --Doanh thu lai, phi: Lai, phi da tra cam co, utct
                           -- SUM(CASE WHEN lnp.paiddate >= dtl.frdate AND lnp.paiddate < dtl.clstxdate and dtl.cfeffdate <= lnp.paiddate and dtl.cfexpdate > lnp.paiddate THEN NVL(lnp.IntRevenue_DF, 0) ELSE 0 END) IntRevenue_DF
                FROM dtl,
                        --Lai phi da tra, lay theo ngay tra, neu ngay tra ma khach hang thuoc moi gioi nao thi tinh cho moi gioi do
                        (
                        SELECT cf.custodycd, lt.TXDATE paiddate,
                                SUM (NVL(lt.NAMT,0)) IntRevenue_DF
                        FROM vw_lntran_all lt, vw_lnmast_all mst, vw_lnschd_all lns, afmast af, cfmast cf, lntype lnt
                        WHERE mst.acctno = lns.acctno
                              AND lns.acctno = lt.acctno
                              AND mst.TRFACCTNO = af.acctno
                              AND af.custid = cf.custid
                              AND mst.ACTYPE = lnt.actype
                              AND mst.ftype = 'DF'
                              AND lt.tltxcd = '2646'
                              AND lt.txcd = '0024'
                             AND lt.TXDATE  BETWEEN v_FromDate AND V_ToDate
                        GROUP BY cf.custodycd, lt.TXDATE
                        ) lnp
              WHERE dtl.custodycd = lnp.custodycd(+)
              GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname*/
              --) lnp3,

              /*(SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname,
                          SUM(CASE WHEN dtl.frdate <= pia.txdate AND dtl.clstxdate > pia.txdate and dtl.cfeffdate <= pia.txdate and dtl.cfexpdate > pia.txdate --check them dk ngay hieu luc cua recflnk
                                    THEN NVL(pia.pia_fee,0) ELSE 0 END) pia_fee
              FROM dtl,
                      --Phi ung truoc
                      (
                      SELECT cf.custodycd, ad.txdate, SUM(ad.feeamt) pia_fee
                      FROM vw_adschd_all ad, afmast af, cfmast cf
                      WHERE ad.acctno = af.acctno
                            AND af.custid = cf.custid
                            AND ad.txdate BETWEEN v_FromDate AND v_ToDate
                      GROUP BY cf.custodycd, ad.txdate
                      ) pia
              WHERE dtl.custodycd = pia.custodycd(+)
              GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname
              ) pia2,*/

 /*             (SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, 0 ext_fee
                          SUM(CASE WHEN dtl.frdate <= ext.txdate AND dtl.clstxdate > ext.txdate and dtl.cfeffdate <= ext.txdate and dtl.cfexpdate > ext.txdate --check them dk ngay hieu luc cua recflnk
                                    THEN NVL(ext.extfee,0) ELSE 0 END) ext_fee
              FROM dtl/*,
                        --Phi gia han
                        (
                        SELECT cf.custodycd, ext.txdate, SUM(ext.exefeeamt) extfee
                        FROM lnschdextlog ext, vw_lnschd_all lns, vw_lnmast_all LN, afmast af, cfmast cf
                        WHERE ext.lnschdid = lns.autoid
                              AND lns.ACCTNO = ln.ACCTNO
                              AND lns.REFTYPE IN ('P','GP')
                              AND ln.FTYPE <> 'DF'
                              AND ln.TRFACCTNO = af.acctno
                              AND af.custid = cf.custid
                              AND ext.txdate BETWEEN v_FromDate AND v_ToDate
                        GROUP BY cf.custodycd, ext.txdate
                        ) ext
              WHERE dtl.custodycd = ext.custodycd(+)
              GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname*/
              --) ext2

/*        WHERE od2.brid = fee2.brid(+)
              AND od2.tlname = fee2.tlname(+)

              AND od2.brid = ci_fee2.brid(+)
              AND od2.tlname = ci_fee2.tlname(+)

              AND od2.brid = lna2.brid(+)
              AND od2.tlname = lna2.tlname(+)

              AND od2.brid = lnp2.brid(+)
              AND od2.tlname = lnp2.tlname(+)

              AND od2.brid = lnp3.brid(+)
              AND od2.tlname = lnp3.tlname(+)

              AND od2.brid = pia2.brid(+)
              AND od2.tlname = pia2.tlname(+)

              AND od2.brid = ext2.brid(+)
              AND od2.tlname = ext2.tlname(+)

GROUP BY od2.brid, od2.brname, od2.tlname, od2.tlfullname
      HAVING  (SUM(fee) + SUM(fee_add) - SUM(fee_revert) + SUM(loan_acr) + SUM(loan_curr) + SUM(loanintfee_curr)
              + SUM(IntFeeRevenue) + SUM(intrev_add) - SUM(intrev_revert) + SUM(pia_fee) + SUM(pia_add)- SUM(pia_revert)
              + SUM(IntCurr_DF) + SUM(IntRevenue_DF) + SUM(ext_fee) + SUM(feerenew_add) - SUM(feerenew_revert) <> 0 OR od2.brid = '0001');
*/
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/
