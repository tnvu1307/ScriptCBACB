SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE RE0025 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                IN       VARCHAR2,
   BRID               IN       VARCHAR2,
   F_DATE           IN       VARCHAR2,
   T_DATE           IN       VARCHAR2,
   I_BRID            IN       VARCHAR2,
   TLNAME         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2,
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
   v_Custodycd  VARCHAR2(30);
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

   IF (upper(PV_CUSTODYCD) = 'ALL' or PV_CUSTODYCD is null)  THEN
       v_Custodycd := '%';
   ELSE
       v_Custodycd := UPPER(PV_CUSTODYCD);
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
/*
     WITH dtl AS
              (
                select tl.brid, br.brname, tl.tlname, tl.tlfullname, kh.custid, kh.custodycd, kh.fullname, af.frdate, af.todate, nvl(af.clstxdate, af.todate) clstxdate,
                         cf.effdate cfeffdate, cf.expdate cfexpdate
                from reaflnk af,recflnk cf, cfmast kh, tlprofiles tl, brgrp br
                WHERE substr(af.reacctno,1,10) = cf.custid
                    AND af.refrecflnkid = cf.autoid
                    and cf.tlid = tl.tlid
                    and af.afacctno = kh.custid
                    AND tl.brid = br.brid
                    AND af.frdate <=  v_ToDate
                    AND kh.opndate <= v_ToDate
                    --AND cf.effdate <= v_ToDate
                    --AND cf.expdate>= v_FromDate --check ngay hieu luc cua recflnk
                    AND NVL(af.clstxdate, af.todate) >= v_FromDate --Chi xet trong khoang thoi gian tao bao cao (het han sau tu ngay)
                    AND tl.tlname LIKE v_TLNAME
                    AND br.brid LIKE v_BridPrm
                    AND kh.custodycd LIKE v_Custodycd
                    --AND cf.status = 'A'
                    --AND af.status = 'A'
                    --Check careby
                    AND EXISTS (select gu.grpid from tlgrpusers gu, afmast afm where gu.tlid = v_TLID AND afm.careby =gu.grpid AND afm.custid = kh.custid)
                )

        SELECT od2.brid, od2.brname, od2.tlname, od2.tlfullname, od2.custodycd, od2.fullname,
                   SUM(MatchedValue_NM) MatchedValue_NM,
                  SUM(MatchedValue_MR) MatchedValue_MR,
                  SUM(fee_NM) + SUM(feeNM_add) - SUM(feeNM_revert) TradingFee_NM,
                  SUM(fee_MR) + SUM(feeMR_add) - SUM(feeMR_revert) TradingFee_MR,
                  SUM(MatchedValue_NM) +  SUM(MatchedValue_MR) MatchedValue,
                  SUM(fee_NM) + SUM(fee_MR) + SUM(feeNM_add) + SUM(feeMR_add) - SUM(feeNM_revert) - SUM(feeMR_revert) TradingFee,
                  SUM(loanintfee_curr) + SUM(IntFeeRevenue) + SUM(intrev_add) - SUM(intrev_revert) int_revenue,
                  SUM(pia_fee) + SUM(pia_add)- SUM(pia_revert) pia_revenue,
                  SUM(IntCurr_DF) + SUM(IntRevenue_DF) + SUM(ext_fee) + SUM(feerenew_add) - SUM(feerenew_revert) ext_revenue
        FROM
              (
                --Phi giao dich: Lay theo ngay de co the xac dinh trong khoang thoi gian do khach hang do moi gioi nao cham soc
                SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname,
                          SUM(CASE WHEN dtl.frdate <= od.txdate AND dtl.clstxdate > od.txdate /*AND dtl.cfeffdate <= od.txdate AND dtl.cfexpdate > od.txdate*/ --THEN nvl(od.MatchedValue_NM,0) ELSE 0 END) MatchedValue_NM,
--                          SUM(CASE WHEN dtl.frdate <= od.txdate AND dtl.clstxdate > od.txdate /*AND dtl.cfeffdate <= od.txdate AND dtl.cfexpdate > od.txdate*/ THEN nvl(od.MatchedValue_MR,0) ELSE 0 END) MatchedValue_MR,
--                          SUM(CASE WHEN dtl.frdate <= od.txdate AND dtl.clstxdate > od.txdate /*AND dtl.cfeffdate <= od.txdate AND dtl.cfexpdate > od.txdate*/ THEN NVL(od.Fee_NM,0) ELSE 0 END) fee_NM,
--                          SUM(CASE WHEN dtl.frdate <= od.txdate AND dtl.clstxdate > od.txdate /*AND dtl.cfeffdate <= od.txdate AND dtl.cfexpdate > od.txdate*/ THEN NVL(od.Fee_MR,0) ELSE 0 END) fee_MR
/*                FROM dtl,
                      (SELECT cfc.custodycd, od.txdate,
                              SUM(CASE WHEN mrt.mrtype = 'N' THEN od.execamt ELSE 0 END) MatchedValue_NM,
                              SUM(CASE WHEN mrt.mrtype = 'T' THEN od.execamt ELSE 0 END) MatchedValue_MR,
                              SUM(CASE WHEN mrt.mrtype = 'N' THEN NVL(DECODE(OD.FEEAMT, 0,DECODE(OD.FEEACR,0,OD.EXECAMT * ODT.DEFFEERATE / 100,OD.FEEACR)),OD.FEEACR) ELSE 0 END) Fee_NM,
                              SUM(CASE WHEN mrt.mrtype = 'T' THEN NVL(DECODE(OD.FEEAMT, 0,DECODE(OD.FEEACR,0,OD.EXECAMT * ODT.DEFFEERATE / 100,OD.FEEACR)),OD.FEEACR) ELSE 0 END) Fee_MR
                      FROM vw_odmast_all od, afmast afc, cfmast cfc, aftype aft, mrtype mrt, odtype odt
                      WHERE od.afacctno = afc.acctno
                            AND afc.custid = cfc.custid
                            AND afc.actype = aft.actype
                            AND aft.mrtype = mrt.actype
                            AND od.ACTYPE = odt.actype
                            AND od.EXECAMT > 0 --lenh khop
                            AND od.DELTD <> 'Y'
                            AND od.txdate BETWEEN v_FromDate AND V_ToDate
                      GROUP BY cfc.custodycd, od.txdate
                      ) od
               WHERE dtl.custodycd = od.custodycd(+)
               GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname
               ) od2,
               (
                SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname,
                          SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate AND dtl.cfeffdate <= fee.txdate AND dtl.cfexpdate > fee.txdate THEN NVL(fee.feeNM_add,0) ELSE 0 END) feeNM_add,
                          SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate AND dtl.cfeffdate <= fee.txdate AND dtl.cfexpdate > fee.txdate THEN NVL(fee.feeMR_add,0) ELSE 0 END) feeMR_add,
                          SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate AND dtl.cfeffdate <= fee.txdate AND dtl.cfexpdate > fee.txdate THEN NVL(fee.intrev_add,0) ELSE 0 END) intrev_add,
                          SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate AND dtl.cfeffdate <= fee.txdate AND dtl.cfexpdate > fee.txdate THEN NVL(fee.intrev_revert,0) ELSE 0 END) intrev_revert,
                          --Doanh thu ung truoc
                          SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate  AND dtl.cfeffdate <= fee.txdate AND dtl.cfexpdate > fee.txdate THEN NVL(fee.pia_add,0) ELSE 0 END) pia_add,
                          SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate  AND dtl.cfeffdate <= fee.txdate AND dtl.cfexpdate > fee.txdate THEN NVL(fee.pia_revert,0) ELSE 0 END) pia_revert,
                          SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate  AND dtl.cfeffdate <= fee.txdate AND dtl.cfexpdate > fee.txdate THEN NVL(fee.feerenew_revert,0) ELSE 0 END) feerenew_revert,
                          SUM(CASE WHEN dtl.frdate <= fee.txdate AND dtl.clstxdate > fee.txdate  AND dtl.cfeffdate <= fee.txdate AND dtl.cfexpdate > fee.txdate THEN NVL(fee.feerenew_add,0) ELSE 0 END) feerenew_add
                FROM dtl,
                --Phi thu them: Tra phi mua/Tra phi ban, phi gia han...............
                           (
                          SELECT tlg.busdate txdate, tlg.cfcustodycd,
                          SUM (CASE WHEN tlg.tltxcd = '1190' AND tlf.txtype IN ('002', '003') AND mrt.mrtype = 'N' THEN tlf.adjvalue ELSE 0 END) feeNM_add,
                          SUM (CASE WHEN tlg.tltxcd = '1190' AND tlf.txtype IN ('002', '003') AND mrt.mrtype = 'T' THEN tlf.adjvalue ELSE 0 END) feeMR_add,
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
                                              AND txdate BETWEEN v_FromDate AND V_ToDate
                          GROUP BY txnum, txdate
                          HAVING MAX((CASE WHEN fldcd = '09' THEN cvalue END) )  IN ('002', '003', '040', '041', '042', '020', '021', '022', '034', '035', '014', '015', '023', '043') --Loai: Tra phi mua/Tra phi ban
                          ) tlf, afmast af, aftype aft, mrtype mrt
                          WHERE tlg.txnum = tlf.txnum
                                AND tlg.txdate = tlf.txdate
                                AND tlg.msgacct = af.acctno
                                AND af.actype = aft.actype
                                AND aft.mrtype = mrt.actype
                                AND tlg.tltxcd IN ('1190', '1191')
                                AND tlg.busdate BETWEEN v_FromDate AND V_ToDate
                          GROUP BY tlg.busdate, tlg.cfcustodycd
                          ) fee
                WHERE dtl.custodycd = fee.cfcustodycd(+)
                GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname
                ) fee2,

                (SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname,
                            SUM(CASE WHEN dtl.frdate <= ci_fee.txdate AND dtl.clstxdate > ci_fee.txdate AND dtl.cfeffdate <= ci_fee.txdate AND dtl.cfexpdate > ci_fee.txdate THEN NVL(ci_fee.feeNM_revert,0) ELSE 0 END) feeNM_revert,
                            SUM(CASE WHEN dtl.frdate <= ci_fee.txdate AND dtl.clstxdate > ci_fee.txdate AND dtl.cfeffdate <= ci_fee.txdate AND dtl.cfexpdate > ci_fee.txdate THEN NVL(ci_fee.feeMR_revert,0) ELSE 0 END) feeMR_revert
                FROM dtl,
                --Phi hoan lai
                          (
                          SELECT ci.custodycd, ci.busdate txdate,
                                 SUM(CASE WHEN mrt.mrtype = 'N' THEN ci.namt ELSE 0 END) feeNM_revert,
                                 SUM(CASE WHEN mrt.mrtype = 'T' THEN ci.namt ELSE 0 END) feeMR_revert
                          FROM vw_citran_gen ci, cimast cim, afmast af, aftype aft, mrtype mrt
                          WHERE ci.tltxcd = '1138'
                                AND ci.txcd = '0012'
                                AND ci.acctno = cim.acctno
                                AND cim.afacctno = af.acctno
                                AND af.actype = aft.actype
                                AND aft.mrtype = mrt.actype
                                AND ci.busdate BETWEEN v_FromDate AND V_ToDate
                          GROUP BY ci.custodycd, ci.busdate
                          ) ci_fee
                WHERE dtl.custodycd = ci_fee.custodycd(+)
                GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname
                ) ci_fee2,

                ( SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname,
              --Du no lai phi hien tai tinh cho moi gioi cuoi cung
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
                            CFMAST CF, AFMAST AF,  CFMAST CFB , LNTYPE LNT
                      WHERE LN.ACCTNO = LS.ACCTNO
                      AND LS.REFTYPE IN ('P','GP')
                      AND LN.ACTYPE = LNT.actype
                      AND LS.RLSDATE /*BETWEEN to_date('23/11/2015','dd/mm/yyyy') AND to_date('23/11/2015','dd/mm/yyyy')*/ --<= v_ToDate
--                      AND LS.AUTOID = LNTR.AUTOID(+)
--                      AND lN.custbank = cfb.custid(+)
                      --CHECK TRANG THAI TAT TOAN
                      /*AND LS.NML+LS.OVD - NVL(LNTR.PRIN_MOVE,0)+LS.INTNMLACR+LS.INTDUE+LS.INTOVD+LS.INTOVDPRIN  - NVL(LNTR.INT_MOVE,0)+  LS.FEEINTNMLACR + LS.FEEINTOVDACR + LS.FEEINTNMLOVD + LS.FEEINTDUE -- +  LS.INTPAID + LS.FEEINTPAID
                                 - NVL(LNTR.PRFEE_MOVE,0)> 0*/
--                      AND CF.CUSTID = AF.CUSTID
--                      AND LN.TRFACCTNO = AF.ACCTNO
                      --AND ln.ftype <> 'DF' --Khong lay du no cam co
                      --AND  (AF.BRID LIKE V_STRBRID OR INSTR(V_STRBRID,AF.BRID) <> 0)
/*                    -- and exists (select gu.grpid from tlgrpusers gu where gu.tlid = V_STRTLID AND af.careby =gu.grpid)
                      GROUP BY  CF.CUSTODYCD, ls.rlsdate
                      ) lna
               WHERE dtl.custodycd = lna.custodycd(+)
               GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname
               ) lna2,

              (SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname,
                        --Doanh thu lai, phi: Lai, phi da tra
                        SUM(CASE WHEN lnp.paiddate >= dtl.frdate AND lnp.paiddate < dtl.clstxdate  AND dtl.cfeffdate <= lnp.paiddate AND dtl.cfexpdate > lnp.paiddate THEN NVL(lnp.IntFeeRevenue, 0) ELSE 0 END) IntFeeRevenue
              FROM dtl,
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
              GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname
              ) lnp2,

              (SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname,
                            --Doanh thu lai, phi: Lai, phi da tra cam co, utct
                            SUM(CASE WHEN lnp.paiddate >= dtl.frdate AND lnp.paiddate < dtl.clstxdate and dtl.cfeffdate <= lnp.paiddate and dtl.cfexpdate > lnp.paiddate THEN NVL(lnp.IntRevenue_DF, 0) ELSE 0 END) IntRevenue_DF
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
              GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname
              ) lnp3,

             (SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname,
                          --Doanh thu phi ung truoc
                        SUM(CASE WHEN dtl.frdate <= pia.txdate AND dtl.clstxdate > pia.txdate AND dtl.cfeffdate <= pia.txdate AND dtl.cfexpdate > pia.txdate THEN NVL(pia.pia_fee,0) ELSE 0 END) pia_fee
             FROM  dtl,
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
              GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname
              ) pia2,

              (SELECT dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname,
                         --Doanh thu phi gia han
                        SUM(CASE WHEN dtl.frdate <= ext.txdate AND dtl.clstxdate > ext.txdate  AND dtl.cfeffdate <= ext.txdate AND dtl.cfexpdate > ext.txdate THEN NVL(ext.extfee,0) ELSE 0 END) ext_fee
              FROM dtl,
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
                 GROUP BY dtl.brid, dtl.brname, dtl.tlname, dtl.tlfullname, dtl.custodycd, dtl.fullname
                ) ext2
        WHERE od2.custodycd = fee2.custodycd
              AND od2.brid = fee2.brid
              AND od2.tlname = fee2.tlname

              AND od2.custodycd = ci_fee2.custodycd
              AND od2.brid = ci_fee2.brid
              AND od2.tlname = ci_fee2.tlname

              AND od2.custodycd = lna2.custodycd
              AND od2.brid = lna2.brid
              AND od2.tlname = lna2.tlname

              AND od2.custodycd = lnp2.custodycd
              AND od2.brid = lnp2.brid
              AND od2.tlname = lnp2.tlname

              AND od2.custodycd = lnp3.custodycd
              AND od2.brid = lnp3.brid
              AND od2.tlname = lnp3.tlname

              AND od2.custodycd = pia2.custodycd
              AND od2.brid = pia2.brid
              AND od2.tlname = pia2.tlname

              AND od2.custodycd = ext2.custodycd
              AND od2.brid = ext2.brid
              AND od2.tlname = ext2.tlname
         GROUP BY od2.brid, od2.brname, od2.tlname, od2.tlfullname, od2.custodycd, od2.fullname
              HAVING ( ( SUM(fee_NM) + SUM(fee_MR) + SUM(feeNM_add) + SUM(feeMR_add) - SUM(feeNM_revert) - SUM(feeMR_revert)
                        + SUM(loanintfee_curr) + SUM(IntFeeRevenue) + SUM(intrev_add) - SUM(intrev_revert)
                        + SUM(pia_fee) + SUM(pia_add)- SUM(pia_revert)
                        + SUM(IntCurr_DF) + SUM(IntRevenue_DF) + SUM(ext_fee) + SUM(feerenew_add) - SUM(feerenew_revert) )  <> 0 OR od2.brid = '0001');

*/
EXCEPTION
   WHEN OTHERS
   THEN
    --dbms_output.put_line(dbms_utility.format_error_backtrace);
      RETURN;
End;
/
