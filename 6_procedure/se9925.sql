SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se9925 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   T_DATE         IN       VARCHAR2
 )
IS
-- Report Name: Bao cao co cau danh muc ty trong dau tu cua to chuc va ca nhan nuoc ngoai
-- Creator: HoangNX
-- Created Date: 19/12/2014

   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (40);
   V_TODATE           DATE;
   V_CURRDATE         DATE;

BEGIN
   V_STROPTION := UPPER(OPT);
   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL') THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%';
   END IF;

   V_TODATE := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

   SELECT TO_DATE(SY.VARVALUE, SYSTEMNUMS.C_DATE_FORMAT) INTO V_CURRDATE
   FROM SYSVAR SY WHERE SY.VARNAME = 'CURRDATE' AND SY.GRNAME = 'SYSTEM';

    OPEN PV_REFCURSOR
      FOR
          WITH mast AS
              (SELECT ci_curr.custodycd, ci_curr.curr_ci_balance - NVL(ci_arsamt,0) rpt_ci_balance
              FROM
                   (SELECT cf.custodycd, SUM(ci.balance) curr_ci_balance
                  FROM ddmast ci, cfmast cf, afmast af
                  WHERE ci.afacctno = af.acctno
                        AND af.custid = cf.custid
                        AND TRIM(SUBSTR(cf.custodycd, 4, 1)) = 'F'
                        AND cf.custatcom = 'Y'
                        AND (af.brid LIKE V_STRBRID OR INSTR(V_STRBRID,af.brid) <> 0)
                   GROUP BY cf.custodycd
                   ) ci_curr,
                   (SELECT custodycd, SUM(ci_arsamt) ci_arsamt
                    FROM
                       (SELECT cf.custodycd, CASE WHEN tr.txtype = 'D' THEN tr.namt * (-1) ELSE tr.namt END ci_arsamt
                       FROM vw_ddtran_gen tr, cfmast cf
                            WHERE tr.custodycd = cf.custodycd
                                  AND tr.deltd <> 'Y'
                                  AND tr.namt > 0
                                  AND tr.field IN ('BALANCE')
                                  AND tr.txtype IN ('C','D')
                                  AND tr.busdate > V_TODATE
                                  AND tr.busdate <= V_CURRDATE
                                  AND TRIM(SUBSTR(tr.custodycd, 4, 1)) = 'F'
                                  AND cf.custatcom = 'Y'
                                  AND (cf.brid LIKE V_STRBRID OR INSTR(V_STRBRID,cf.brid) <> 0)
                        )
                   GROUP BY custodycd
                   ) ci_ars
              WHERE ci_curr.custodycd = ci_ars.custodycd(+)
              )
          --
          SELECT custtype_grp, tradingcode, custname, nvl(SUM(se_listed),0) se_listed, nvl(SUM(se_unlisted),0) se_unlisted,
                 nvl(SUM(se_others),0) se_others, nvl(SUM(rpt_ci_balance),0) rpt_ci_balance,
                 nvl(SUM(se_listed),0) + nvl(SUM(se_unlisted),0) + nvl(SUM(se_others),0) + nvl(SUM(rpt_ci_balance),0) portfolio_value,
                 CASE WHEN (nvl(SUM(se_listed),0) + nvl(SUM(se_unlisted),0) + nvl(SUM(se_others),0)) = 0 THEN 0
                      ELSE ROUND(nvl(SUM(se_listed),0) * 100/(nvl(SUM(se_listed),0) + nvl(SUM(se_unlisted),0) + nvl(SUM(se_others),0)),2)
                 END listed_rate,
                 CASE WHEN (nvl(SUM(se_listed),0) + nvl(SUM(se_unlisted),0) + nvl(SUM(se_others),0)) = 0 THEN 0
                      ELSE round(nvl(SUM(se_unlisted),0) * 100/(nvl(SUM(se_listed),0) + nvl(SUM(se_unlisted),0) + nvl(SUM(se_others),0)),2)
                 END unlisted_rate,
                 CASE WHEN (nvl(SUM(se_listed),0) + nvl(SUM(se_unlisted),0) + nvl(SUM(se_others),0)) = 0 THEN 0
                      ELSE round(nvl(SUM(se_others),0) * 100/(nvl(SUM(se_listed),0) + nvl(SUM(se_unlisted),0) + nvl(SUM(se_others),0)),2)
                 END others_rate
          FROM
          (
              SELECT --CASE WHEN cf.CUSTTYPE = 'I' THEN 'B. C?h? ELSE 'A. T? ch?c' END custtype_grp,
                     (select cdcontent from allcode  where cdtype= 'CF' AND CDNAME = 'CUSTTYPE' AND CDVAL = cf.CUSTTYPE) custtype_grp,
                     --CASE WHEN cf.custtype <> 'I' THEN cf.custodycd ELSE NULL END tradingcode,
                     cf.tradingcode tradingcode,
                     --CASE WHEN cf.custtype <> 'I' THEN cf.fullname ELSE NULL END custname,
                     cf.fullname custname,
                     SUM(dtl.se_listed) se_listed, SUM(dtl.se_unlisted) se_unlisted, SUM(dtl.se_others) se_others,
                     SUM(mast.rpt_ci_balance) rpt_ci_balance
              FROM
                  (
                  SELECT mst.custodycd,
                         SUM(CASE WHEN mst.tradeplace IN ('001','002', '005') THEN rpt_se_balance ELSE 0 END) se_listed,
                         SUM(CASE WHEN mst.tradeplace NOT IN ('001','002', '005') THEN rpt_se_balance ELSE 0 END) se_unlisted,
                         0 se_others
                  FROM
                      (SELECT se_curr.custtype, se_curr.custodycd, se_curr.codeid, se_curr.tradeplace,
                      --se_curr.curr_se_balance - nvl(se_ars.se_arsamt,0) rpt_se_balance
                      (se_curr.curr_se_qtty - nvl(se_ars.se_arsqtty,0))
                      * CASE WHEN se_curr.tradeplace IN ('001','002', '005') THEN  inf.BASICPRICE
                        ELSE  se_curr.PARVALUE
                      END rpt_se_balance

                      FROM    (select codeid ,BASICPRICE from vw_securities_info_hist where histdate = V_TODATE) inf,
                              --So du SE hien tai
                              (SELECT cf.custtype, cf.custodycd, se.codeid, sb.tradeplace,SB.PARVALUE,
                                      --ROUND(SUM((se.trade + se.mortage + se.blocked + se.netting + se.wtrade)* nvl(inf.basicprice, sb.parvalue))) curr_se_balance
                                      SUM(se.trade + se.mortage + se.blocked + se.netting + se.wtrade) curr_se_qtty
                              FROM semast se, cfmast cf, afmast af,  sbsecurities sb
                              WHERE se.afacctno = af.acctno
                                    AND af.custid = cf.custid
                                    AND se.codeid = sb.codeid

                                    AND sb.sectype IN ('001','002','007','008','111','011')
                                    AND TRIM(SUBSTR(cf.custodycd, 4, 1)) = 'F'
                                    AND cf.custatcom = 'Y'
                                    AND (af.brid LIKE V_STRBRID OR INSTR(V_STRBRID,af.brid) <> 0)
                               GROUP BY cf.custtype, cf.custodycd, se.codeid, sb.tradeplace,SB.PARVALUE
                               ) se_curr,
                               --so du SE phat sinh tu ngay bao cao den ngay hien tai
                               (SELECT cf.custtype, cf.custodycd, tr.codeid, sb.tradeplace,
                                       --ROUND(SUM((CASE WHEN tr.txtype = 'D' THEN tr.namt * (-1) ELSE tr.namt END) * inf.basicprice)) se_arsamt
                                       SUM(CASE WHEN tr.txtype = 'D' THEN tr.namt * (-1) ELSE tr.namt END) se_arsqtty
                               FROM vw_setran_gen tr, cfmast cf, afmast af,  sbsecurities sb
                                    WHERE tr.afacctno = af.acctno
                                          AND af.custid = cf.custid
                                          AND tr.custodycd = cf.custodycd
                                          AND tr.codeid = sb.codeid
                                          AND tr.deltd <> 'Y'
                                          AND tr.namt > 0
                                          AND tr.field IN ('TRADE', 'MORTAGE', 'BLOCKED', 'NETTING', 'WTRADE')
                                          AND sb.sectype IN ('001','002','007','008','111','011')
                                          AND tr.txtype IN ('C','D')
                                          AND tr.busdate > V_TODATE
                                          AND tr.busdate <= V_CURRDATE
                                          AND TRIM(SUBSTR(tr.custodycd, 4, 1)) = 'F'
                                          AND cf.custatcom = 'Y'
                                          AND (cf.brid LIKE V_STRBRID OR INSTR(V_STRBRID,cf.brid) <> 0)
                               GROUP BY cf.custtype, cf.custodycd, tr.codeid, sb.tradeplace
                               ) se_ars
                      WHERE se_curr.custodycd = se_ars.custodycd(+)
                            AND se_curr.codeid = se_ars.codeid(+)
                            and se_curr.codeid = inf.codeid(+)
                      ) mst
                  GROUP BY mst.custodycd
                  ) dtl
              FULL JOIN mast ON mast.custodycd = dtl.custodycd
              INNER JOIN cfmast cf ON cf.custodycd = mast.custodycd
              GROUP BY cf.custtype, cf.custodycd, cf.fullname,cf.tradingcode
          )
          GROUP BY custtype_grp, tradingcode, custname;

EXCEPTION
   WHEN OTHERS THEN RETURN;

END SE9925;
/
