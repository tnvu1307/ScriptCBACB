SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd6013 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_AMCCODE              IN       VARCHAR2, /*Ma AMC */
   PV_CUSTODYCD           IN       VARCHAR2, /*So TK Luu ky */
   P_CLIENTGR             IN       VARCHAR2  /*Loai KH 1,2,3,ALL */
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- Tri.Bui     02-07-2020          created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    --
    V_AMC     VARCHAR2(20);
    V_CUSTODYCD     VARCHAR2(20);
    V_FROMDATE          DATE;
    V_TODATE            DATE;
    V_QTTY              NUMBER;
    V_VSDNETTRFRATE     NUMBER;
    V_VSDMAXTRFAMT     NUMBER;
    V_VSDNETTRFRATE_TPRL     NUMBER;
    V_VSDMAXTRFAMT_TPRL     NUMBER;
    V_SUMALL NUMBER;
BEGIN
     V_STROPTION := OPT;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;
     ----
     IF UPPER(P_AMCCODE) = 'ALL' THEN
        V_AMC := '%';
     ELSE
        V_AMC:= UPPER(P_AMCCODE);
     END IF;
     ----
     V_CUSTODYCD:= REPLACE(PV_CUSTODYCD,'.','');
     IF UPPER(V_CUSTODYCD) = 'ALL' THEN
        V_CUSTODYCD := '%';
     ELSE
        V_CUSTODYCD:= UPPER(V_CUSTODYCD);
     END IF;
     ----
     V_FROMDATE  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
     V_TODATE    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
     V_VSDNETTRFRATE := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'VSDNETTRFRATE');
     V_VSDMAXTRFAMT := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'VSDMAXTRFAMT');
     V_VSDNETTRFRATE_TPRL := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'VSDNETTRFRATE_TPRL');
     V_VSDMAXTRFAMT_TPRL := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'VSDMAXTRFAMT_TPRL');

    OPEN PV_REFCURSOR FOR
    WITH TMPQUANTITY AS (
        SELECT
            'From '||TO_CHAR(V_FROMDATE,'DD/MM/RRRR')||' to '||TO_CHAR(V_TODATE,'DD/MM/RRRR') AS REPORT_PERIOD,
            CASE WHEN V_AMC ='%' THEN 'ALL' ELSE UPPER(FA.FULLNAME) END GROUP_NAME,
            CF.CIFID,
            CF.FULLNAME,
            CF.CUSTID,
            '8893' TLTXCD,
            OD.TXNUM,
            'SELLING' TRANSACTION_TYPE,
            OD.SYMBOL,
            OD.TRADEPLACE,
            TO_CHAR(OD.TRADE_DATE,'DD/MM/RRRR') TXDATE,
            TO_CHAR(OD.CLEARDATE,'DD/MM/RRRR') AS SETTLEMENT_DATE,
            EXECQTTY AS QTTY
            --CASE WHEN ROUND(EXECQTTY*V_VSDNETTRFRATE,2) > V_VSDMAXTRFAMT THEN V_VSDMAXTRFAMT ELSE  ROUND(EXECQTTY*V_VSDNETTRFRATE) END AS AMT
            --ROUND(EXECQTTY*V_VSDNETTRFRATE,2)AS AMT
        FROM
        (
            SELECT OD.*, SB.TRADEPLACE
            FROM
            (
                SELECT * FROM ODMAST WHERE DELTD <> 'Y'
                UNION ALL
                SELECT * FROM ODMASTHIST WHERE DELTD <> 'Y'
            )OD, SBSECURITIES SB
            WHERE OD.CODEID = SB.CODEID AND OD.ORSTATUS ='7'--HOAN THANH
            AND SB.SECTYPE IN ('001','002','008','011','015','003','006','005','012') --CP, CCQ, CW, TP, CONG CU NO
            AND SB.TRADEPLACE IN ('001','002','005','010','099')--TRIBUI 03/07/2020 SAN HOSE,HNX,UPCOM,BOND
        )OD, CFMAST CF, AFMAST AF, (SELECT * FROM FAMEMBERS WHERE ROLES ='AMC')FA
        WHERE OD.AFACCTNO = AF.ACCTNO
        AND CF.CUSTID = AF.CUSTID
        AND CF.AMCID = FA.AUTOID(+)
        AND OD.EXECTYPE IN ('NS','SS','MS')
        AND NVL(FA.SHORTNAME,'%') LIKE V_AMC
        AND CF.CUSTODYCD LIKE V_CUSTODYCD
        AND OD.CLEARDATE >= V_FROMDATE AND OD.CLEARDATE <= V_TODATE
        AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
              WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
              WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
              WHEN P_CLIENTGR = 'ALL' THEN 1
              ELSE 0 END) = 1

        UNION ALL---------------------------------------------------------------

        SELECT
            'From '||TO_CHAR(V_FROMDATE,'DD/MM/RRRR')||' to '||TO_CHAR(V_TODATE,'DD/MM/RRRR') AS REPORT_PERIOD,
            CASE WHEN V_AMC ='%' THEN 'ALL' ELSE UPPER(FA.FULLNAME) END GROUP_NAME,
            CF.CIFID,
            CF.FULLNAME,
            CF.CUSTID,
            SE.TLTXCD,
            SE.TXNUM,
            'SELLING' TRANSACTION_TYPE,
            SE.SYMBOL,
            SE.TRADEPLACE,
            TO_CHAR(SE.TXDATE,'DD/MM/RRRR') TXDATE,
            TO_CHAR(SE.SETTLEMENT_DATE,'DD/MM/RRRR')SETTLEMENT_DATE,
            SUM(SE.NAMT) AS QTTY
            --CASE WHEN ROUND(SUM(SE.NAMT)*V_VSDNETTRFRATE,2) > V_VSDMAXTRFAMT THEN V_VSDMAXTRFAMT ELSE  ROUND(SUM(SE.NAMT)*V_VSDNETTRFRATE) END AS AMT
            --ROUND(SUM(SE.NAMT)*V_VSDNETTRFRATE,2)AS AMT
        FROM
        (
            SELECT *
            FROM
            (
                SELECT AFACCTNO,SYMBOL,TRADEPLACE,TLTXCD,MAX(TXDATE)OVER (PARTITION BY AFACCTNO,SYMBOL,TLTXCD) TXDATE,MAX(SETTLEMENT_DATE)SETTLEMENT_DATE,MAX(TXNUM)TXNUM,MAX(NAMT)NAMT
                FROM
                (
                    SELECT
                        SE.AFACCTNO,SE.TXTIME,
                        (CASE WHEN SE.TLTXCD = '2247' THEN SE.TXDATE
                              WHEN SE.TLTXCD = '2314' THEN SE.TXDATE
                              WHEN SE.TLTXCD = '2266' THEN SED.TXDATE
                              ELSE NULL END) TXDATE ,
                        (CASE WHEN SE.TLTXCD IN ('2248', '2266', '2314') THEN SE.TXDATE ELSE NULL END) SETTLEMENT_DATE,
                        (CASE WHEN SE.TLTXCD = '2247' THEN NULL ELSE SE.TXNUM END) TXNUM,
                        SE.SYMBOL, SB.TRADEPLACE,
                        (CASE WHEN SE.TLTXCD = '2247' THEN '2248' ELSE SE.TLTXCD END) TLTXCD,
                        (CASE WHEN SE.TLTXCD = '2247' THEN 0 ELSE SE.NAMT END) NAMT
                    FROM VW_SETRAN_GEN SE, SBSECURITIES SB, (SELECT SED.*, SED.AFACCTNO||SED.CODEID ACCTNO FROM SE2255_LOG SED) SED
                    WHERE SE.CODEID = SB.CODEID AND SE.ACCTNO=SED.ACCTNO(+) AND SE.NAMT=SED.TRADE(+) AND SE.CODEID =SED.CODEID(+) AND SE.TXDATE = SED.TXDATE(+)
                    AND ((SE.TLTXCD IN ('2266', '2314') AND SE.FIELD = 'WITHDRAW') OR (SE.TLTXCD IN ('2247', '2248') AND SE.FIELD = 'DTOCLOSE') )
                    AND SE.DELTD <> 'Y'
                    AND SB.SECTYPE IN ('001','002','008','011','015','003','006','005','012') --CP, CCQ, CW, TP, CONG CU NO
                    AND SB.TRADEPLACE IN ('001','002','005','010','099')--TRIBUI 03/07/2020 SAN HOSE,HNX,UPCOM,BOND
                    AND SE.TXDATE <= V_TODATE
                )A GROUP BY AFACCTNO,SYMBOL,TRADEPLACE,TLTXCD,TXDATE,TXTIME
            )B WHERE NAMT <>0
        ) SE, CFMAST CF, AFMAST AF, (SELECT * FROM FAMEMBERS WHERE ROLES ='AMC')FA
        WHERE SE.AFACCTNO = AF.ACCTNO
        AND CF.CUSTID = AF.CUSTID
        AND CF.CUSTATCOM ='Y'
        AND CF.AMCID = FA.AUTOID(+)
        AND CF.CUSTODYCD LIKE V_CUSTODYCD
        AND NVL(FA.SHORTNAME,'%') LIKE V_AMC
        AND SE.SETTLEMENT_DATE >= V_FROMDATE AND SE.SETTLEMENT_DATE <= V_TODATE
        AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
              WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
              WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
              WHEN P_CLIENTGR = 'ALL' THEN 1
              ELSE 0 END) = 1
        GROUP BY FA.FULLNAME,CF.CIFID,CF.CUSTID,CF.FULLNAME,SE.TXNUM,SE.SYMBOL,SE.TRADEPLACE,SE.TXDATE,SE.SETTLEMENT_DATE,SE.TLTXCD
        HAVING SUM(SE.NAMT) > 0
    ),
    TMPQUANTITY_CAL AS (
        SELECT TM.*, SUM(TM.QTTY) OVER(PARTITION BY SETTLEMENT_DATE, SYMBOL, TRADEPLACE) AS SUM_QTTY
        FROM TMPQUANTITY TM
    )
    SELECT NFA.REPORT_PERIOD,GROUP_NAME,CF.CIFID,CF.FULLNAME,TLTXCD,TXNUM,TRANSACTION_TYPE,
        SYMBOL,TXDATE,SETTLEMENT_DATE,QTTY,SUM_QTTY,CF.CUSTODYCD,CF.MCUSTODYCD,CF.MCIFID,A0.CDCONTENT DESCCOUNTRY,
        (CASE WHEN NFA.TRADEPLACE = '099' THEN
             (CASE WHEN ROUND(SUM_QTTY * V_VSDNETTRFRATE_TPRL) > V_VSDMAXTRFAMT_TPRL THEN ROUND((NFA.QTTY/(CASE WHEN NFA.SUM_QTTY = 0 THEN 1 ELSE NFA.SUM_QTTY END))* V_VSDMAXTRFAMT_TPRL ,0)
                   ELSE ROUND(NFA.QTTY * V_VSDNETTRFRATE_TPRL,0)
             END)
             ELSE
             (CASE WHEN ROUND(SUM_QTTY * V_VSDNETTRFRATE) > V_VSDMAXTRFAMT THEN ROUND((NFA.QTTY/(CASE WHEN NFA.SUM_QTTY = 0 THEN 1 ELSE NFA.SUM_QTTY END))* V_VSDMAXTRFAMT ,0)
                   ELSE ROUND(NFA.QTTY * V_VSDNETTRFRATE,0)
             END)
        END)  AMT
    FROM TMPQUANTITY_CAL NFA, CFMAST CF,
    (SELECT * FROM ALLCODE WHERE CDNAME = 'COUNTRY' AND CDTYPE = 'CF') A0
    WHERE CF.CUSTID = NFA.CUSTID
    AND CF.COUNTRY = A0.CDVAL
    AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
              WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
              WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
              WHEN P_CLIENTGR = 'ALL' THEN 1
              ELSE 0 END) = 1
    ORDER BY NFA.SETTLEMENT_DATE, NFA.SYMBOL;

EXCEPTION WHEN OTHERS THEN
    PLOG.ERROR ('DD6013: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN;
END;
/
