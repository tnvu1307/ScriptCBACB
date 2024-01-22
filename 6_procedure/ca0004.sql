SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca0004 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   CACODE         IN       VARCHAR2,
   CUSTODYCD       IN       VARCHAR2
  )
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO QUYEN MUA
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- LOCPT       20141208
-- ---------   ------  -------------------------------------------

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);
    V_STRCACODE    VARCHAR2 (20);
    V_CUSTODYCD   VARCHAR2 (20);
    v_cuurdate      date;
BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   IF (CACODE <> 'ALL')
   THEN
      V_STRCACODE := CACODE;
   ELSE
      V_STRCACODE := '%%';
   END IF;

   IF (CUSTODYCD <> 'ALL')
   THEN
      V_CUSTODYCD := CUSTODYCD;
   ELSE
      V_CUSTODYCD := '%%';
   END IF;

    v_cuurdate := getcurrdate;


OPEN PV_REFCURSOR
   FOR



        SELECT CACODE INPUT_CACODE,
               nvl(se.custodycd, ci.custodycd) custodycd,
               NVL(CI.ACCTNO,SE.ACCTNO) ACCTNO,
               CF.FULLNAME,
               nvl(se.trade, ci.trade) trade,
               nvl(se.maxqtty, ci.maxqtty) BALANCE,
               CASE WHEN tl.tltxcd = '3324' THEN 0 ELSE  nvl(se.exprice, ci.exprice) END PARVALUE,
               tl.msgamt QTTY,
               CASE WHEN tl.tltxcd = '3324' THEN 0 ELSE tl.msgamt * nvl(se.exprice, ci.exprice) END AMOUNT,
               nvl(se.maxqtty, ci.maxqtty) - tl.msgamt REMAIN,
               TL.TXDATE ACTIONDATE,TL.TXNUM,
               br_tl.brname BRNAME2,
               re.fullname BROKERNAME,
               re.brname BRNAME,
               '' RES, '' CONFIRM,
               A1.CDCONTENT TRADEPLACE,
               nvl(se.REPORTDATE, ci.REPORTDATE) REPORTDATE,
               nvl(se.EXRATE, ci.EXRATE) EXRATE,
               nvl(se.casymbol, ci.casymbol) OPTsymbol


        FROM vw_tllog_all tl,  cfmast cf, afmast af, brgrp br_tl,
            (SELECT se.*, ca.codeid cacodeid, ca.exprice, ca.camastid, sb.symbol casymbol,chd.qtty + chd.pqtty maxqtty,chd.trade,
                CA.REPORTDATE,CA.rightoffrate EXRATE
                FROM vw_setran_gen se, caschd chd, camast ca, sbsecurities sb
                WHERE to_char(chd.autoid) = se.REF AND chd.camastid = ca.camastid
                AND se.field = 'RECEIVING' AND sb.codeid = ca.codeid
                ) se,
            (SELECT ci.*, ca.codeid cacodeid, ca.exprice, ca.camastid, sb.symbol casymbol, chd.qtty + chd.pqtty maxqtty,chd.trade,
                SB.TRADEPLACE,CA.REPORTDATE,CA.rightoffrate EXRATE
                FROM vw_ddtran_gen ci, caschd chd, camast ca, sbsecurities sb
                WHERE to_char(chd.autoid) = ci.REF AND chd.camastid = ca.camastid
                AND ci.field = 'BALANCE' AND sb.codeid = ca.codeid
                ) ci,
                VW_REINFO re,
                ALLCODE A1

        WHERE  tl.tltxcd IN ( '3384', '3394', '3324') AND tl.deltd <> 'Y'
            AND cf.custid = af.custid AND af.acctno = tl.msgacct
            AND tl.txdate = se.txdate (+) AND tl.txnum = se.txnum(+) --AND se.field = 'RECEIVING'
            AND tl.txdate = ci.txdate (+) AND tl.txnum = ci.txnum (+) --AND ci.field = 'BALANCE'
            and tl.brid = br_tl.brid
            AND A1.CDTYPE = 'SE' AND A1.CDNAME =  'TRADEPLACE'
            AND A1.CDVAL = nvl(SE.tradeplace,CI.tradeplace)
            AND  NVL(FN_GETCAREBYDIRECTBROKER(CF.CUSTID,v_cuurdate),-1) = RE.AUTOID(+)
            ---AND NVL(CI.camastid,SE.camastid) LIKE V_STRCACODE
           ---AND cf.custodycd LIKE V_CUSTODYCD

 ;


EXCEPTION
   WHEN OTHERS
   THEN
    plog.error ('CA0004: ' || SQLERRM || dbms_utility.format_error_backtrace);
      RETURN;
END;                                                              -- PROCEDURE
/
