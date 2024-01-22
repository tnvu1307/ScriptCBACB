SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE od6021 (
    PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
    OPT            IN       VARCHAR2,
    BRID           IN       VARCHAR2,
    I_DATE         IN       VARCHAR2,
    PV_CUSTODYCD   IN       VARCHAR2,
    PV_SYMBOL      IN       VARCHAR2
)
IS
    -- ReportName: SSC Daily
    -- OD6021:     Main proc
    -- Person      Date                 Comments
    -- ---------   ------               -------------------------------------------
    -- NAM.LY      08-04-2020           created
    V_STROPTION    VARCHAR2 (5);        -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);        -- USED WHEN V_NUMOPTION > 0
    --
    V_REPORTDATE   DATE;
    V_CUSTODYCD    VARCHAR2(20);
    V_SYMBOL       VARCHAR2(20);
BEGIN
    V_STROPTION := OPT;
    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:= BRID;
    END IF;
    --
    IF  (PV_CUSTODYCD <> 'ALL')
    THEN
         V_CUSTODYCD := PV_CUSTODYCD;
    ELSE
         V_CUSTODYCD := '%';
    END IF;
    --
    IF  (PV_SYMBOL <> 'ALL')
    THEN
         V_SYMBOL := PV_SYMBOL;
    ELSE
         V_SYMBOL := '%';
    END IF;
    --
    V_REPORTDATE := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    ----------------------------------------------------------
    OPEN PV_REFCURSOR
    FOR
        SELECT *
        FROM (
                SELECT CF.FULLNAME,
                       CF.CUSTODYCD,
                       CF.TRADINGCODE,
                       SB.CODEID,
                       SB.SYMBOL,
                       NVL(OD_SELL.EXECQTTY,0) EXECQTTY_SELL,
                       NVL(OD_SELL.EXECAMT,0) EXECAMT_SELL,
                       NVL(OD_BUY.EXECQTTY,0) EXECQTTY_BUY,
                       NVL(OD_BUY.EXECAMT,0) EXECAMT_BUY,
                       NVL(OD_SELL.EXECQTTY,0) + NVL(OD_BUY.EXECQTTY,0) EXECQTTY_TOTAL,
                       NVL(OD_SELL.EXECAMT,0) + NVL(OD_BUY.EXECAMT,0) EXECAMT_TOTAL
                FROM SEMAST SE, SBSECURITIES SB, CFMAST CF,
                        (
                            SELECT OD.SEACCTNO,
                                  OD.TRADE_DATE,
                                  OD.TXNUM,
                                  SUM(NVL(OD.EXECQTTY,0)) EXECQTTY,
                                  SUM(NVL(OD.EXECAMT,0)) EXECAMT
                            FROM VW_ODMAST_ALL OD
                            WHERE OD.EXECTYPE IN ('NS')
                            AND OD.TRADE_DATE = V_REPORTDATE
                            AND OD.ODTYPE <> 'SWE'
                            AND OD.DELTD <> 'Y'
                            GROUP BY OD.SEACCTNO, OD.TRADE_DATE, OD.TXNUM
                        ) OD_SELL,
                        (
                            SELECT OD.SEACCTNO,
                                  OD.TRADE_DATE,
                                  OD.TXNUM,
                                  SUM(NVL(OD.EXECQTTY,0)) EXECQTTY,
                                  SUM(NVL(OD.EXECAMT,0)) EXECAMT
                            FROM VW_ODMAST_ALL OD
                            WHERE  OD.EXECTYPE IN ('NB')
                            AND OD.TRADE_DATE = V_REPORTDATE
                            AND OD.ODTYPE <> 'SWE'
                            AND OD.DELTD <> 'Y'
                            GROUP BY OD.SEACCTNO, OD.TRADE_DATE, OD.TXNUM
                        ) OD_BUY
                WHERE     SE.CODEID = SB.CODEID
                      AND CF.CUSTID = SE.AFACCTNO
                      AND CF.CUSTATCOM = 'Y'
                      AND CF.COUNTRY <> '234'
                      AND SE.ACCTNO = OD_SELL.SEACCTNO(+)
                      AND SE.ACCTNO = OD_BUY.SEACCTNO(+)
                      AND NOT (OD_SELL.SEACCTNO IS NULL AND OD_BUY.SEACCTNO IS NULL)
                      AND SB.SYMBOL LIKE V_SYMBOL
                      AND CF.CUSTODYCD LIKE V_CUSTODYCD
                ORDER BY  NVL(OD_SELL.EXECAMT,0) + NVL(OD_BUY.EXECAMT,0) DESC, NVL(OD_SELL.EXECQTTY,0) + NVL(OD_BUY.EXECQTTY,0) DESC
            )
        WHERE ROWNUM <= 20;
    EXCEPTION
      WHEN OTHERS
       THEN
       DBMS_OUTPUT.PUT_LINE('OD6021 ERROR');
       PLOG.ERROR('OD6021: - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
          RETURN;
END;
/
