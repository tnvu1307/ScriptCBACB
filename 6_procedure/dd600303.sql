SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd600303 (
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
    -- du.phan    23-10-2019           created
    -- nam.ly     06-12-2019           last updated
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    --
    v_FromDate          date;
    v_ToDate            date;
    v_CurrDate          date;
    v_Nextdate          date;
    v_Prevdate          date;
    v_qtty              number;
    v_amt               number;
    v_qtty2266_2248     number;
    v_amt2266_2248     number;
    v_VSDNETTRFRATE     number;
    V_VSDMAXTRFAMT      NUMBER;
    v_VSDNETTRFRATE_TPRL     number;
    V_VSDMAXTRFAMT_TPRL      NUMBER;
    V_AMC           VARCHAR2(20);
    V_CUSTODYCD     VARCHAR2(20);

BEGIN
     V_STROPTION := OPT;
     v_CurrDate   := getcurrdate;
     if v_stroption = 'A' then
        v_strbrid := '%';
     elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
     else
        v_strbrid:=brid;
     end if;

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
--------------------------------------------------------------------------------
    v_FromDate  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_Prevdate  := fn_get_prevdate(v_FromDate,1);
    v_Nextdate  := fn_get_nextdate(v_FromDate,1);
--------------------------------------------------------------------------------
    V_VSDNETTRFRATE := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'VSDNETTRFRATE');
    V_VSDMAXTRFAMT := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'VSDMAXTRFAMT');
    V_VSDNETTRFRATE_TPRL := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'VSDNETTRFRATE_TPRL');
    V_VSDMAXTRFAMT_TPRL := CSPKS_SYSTEM.FN_GET_SYSVAR('SYSTEM', 'VSDMAXTRFAMT_TPRL');

    WITH TMPQUANTITY AS
    (
        SELECT OD.CODEID,
            OD.CLEARDATE TXDATE,
            SUM(CASE WHEN OD.EXECTYPE IN ('NS','SS','MS') THEN EXECQTTY ELSE 0 END)  BT,
            SUM(CASE WHEN OD.EXECTYPE IN ('NS','SS','MS') THEN EXECQTTY * (CASE WHEN OD.TRADEPLACE = '099' THEN V_VSDNETTRFRATE_TPRL ELSE V_VSDNETTRFRATE END) ELSE 0 END) AMT
        FROM
        (
            SELECT OD.*, SB.TRADEPLACE
            FROM
            (
                SELECT * FROM ODMAST WHERE DELTD <> 'Y'
                UNION ALL
                SELECT * FROM ODMASTHIST WHERE DELTD <> 'Y'
            )OD, SBSECURITIES SB
            WHERE OD.CODEID = SB.CODEID
            AND SECTYPE IN ('001','002','008','011','015','003','006','005','012') --CP, CCQ, CW, TP, CONG CU NO
            AND SB.TRADEPLACE IN ('001','002','005','010','003','006','099')--TRIBUI 03/07/2020 SAN HOSE,HNX,UPCOM,BOND,OTC
        ) OD, CFMAST CF, AFMAST AF, (SELECT * FROM FAMEMBERS WHERE ROLES = 'AMC') FA
        WHERE OD.AFACCTNO = AF.ACCTNO
        AND CF.CUSTID = AF.CUSTID
        AND CF.CUSTATCOM ='Y'
        AND CF.AMCID = FA.AUTOID(+)
        AND CF.CUSTODYCD LIKE V_CUSTODYCD
        AND NVL(FA.SHORTNAME,'%') LIKE V_AMC
        AND OD.CLEARDATE >= V_FROMDATE AND OD.CLEARDATE <= V_TODATE
        AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
              WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
              WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
              WHEN P_CLIENTGR = 'ALL' THEN 1
              ELSE 0 END) = 1
        GROUP BY OD.CODEID, OD.CLEARDATE
    )
    SELECT NVL(SUM(BT),0), NVL(SUM(AMT),0)
    INTO V_QTTY, V_AMT
    FROM TMPQUANTITY;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
    WITH TMP2266_2248 AS
    (
        SELECT
            SE.CODEID,
            SE.TXDATE,
            SUM(SE.NAMT)BT,
            SUM(SE.NAMT * (CASE WHEN SE.SBTRADEPLACE = '099' THEN V_VSDNETTRFRATE_TPRL ELSE V_VSDNETTRFRATE END)) AMT
        FROM
        (
            SELECT SE.*, SB.TRADEPLACE SBTRADEPLACE
            FROM VW_SETRAN_GEN SE, SBSECURITIES SB
            WHERE SE.CODEID = SB.CODEID
            AND SE.TLTXCD IN ('2248','2266','2314')
            AND SE.DELTD <> 'Y'
            AND SB.SECTYPE IN ('001','002','008','011','015','003','006','005','012') --CP, CCQ, CW, TP, CONG CU NO
            AND SB.TRADEPLACE IN ('001','002','005','010','003','006','099')--TRIBUI 03/07/2020 SAN HOSE,HNX,UPCOM,BOND,OTC
        ) SE, CFMAST CF, AFMAST AF,(SELECT * FROM FAMEMBERS WHERE ROLES ='AMC')FA
        WHERE SE.AFACCTNO = AF.ACCTNO
        AND CF.CUSTID = AF.CUSTID
        AND CF.CUSTATCOM ='Y'
        AND CF.AMCID = FA.AUTOID(+)
        AND CF.CUSTODYCD LIKE V_CUSTODYCD
        AND NVL(FA.SHORTNAME,'%') LIKE V_AMC
        AND SE.TXDATE >= V_FROMDATE AND SE.TXDATE <= V_TODATE
        AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
              WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
              WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
              WHEN P_CLIENTGR = 'ALL' THEN 1
              ELSE 0 END) = 1
        GROUP BY SE.CODEID, SE.TXDATE
    )
    SELECT NVL(SUM(BT),0), NVL(SUM(AMT), 0)
    INTO V_QTTY2266_2248, V_AMT2266_2248
    FROM TMP2266_2248;



    OPEN PV_REFCURSOR FOR
    with  tmpNameOfAccount as (
        Select 'Clearing settlement transaction (D)'  NAMEOFACCOUNT,'D' CFTYPE, V_QTTY QTTY, ROUND(V_AMT,0) AMT, '' NOTE  FROM DUAL
        union all
        Select 'Securities transfer (E)' NAMEOFACCOUNT,'E' CFTYPE, V_QTTY2266_2248 QTTY, ROUND(V_AMT2266_2248,0) AMT, '' NOTE FROM DUAL
    )
    Select  *
    from tmpNameOfAccount nfa;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('DD600303: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
