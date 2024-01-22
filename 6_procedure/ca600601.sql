SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca600601(
      PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_AMCCODE              IN       VARCHAR2, /* Ma AMC */
   PV_TXNUM               IN       VARCHAR2 /*SO CHUNG TU*/
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- NAM.LY     11-12-2019           CREATED
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    v_FromDate          date;
    v_ToDate            date;
    v_CurrDate          date;
    v_issuedate         date;
    v_expdate           date;
    v_CustodyCD         varchar2(20);
    v_Symbol            varchar2(50);
    v_IDCODE           varchar2(200);
    v_OFFICE           varchar2(200);
    v_REFNAME          varchar2(200);
    v_shvstc           varchar2(200);
    v_shvcustodycd     varchar2(200);
    v_shvcifid         varchar2(200);

    v_tltitle          varchar2(200);
    v_tlfullname       varchar2(200);
    v_ExchangeRate     number;
    v_AMCCODE          varchar2(20);
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
    if P_AMCCODE='ALL' then
        v_AMCCODE:='%';
    else
    v_AMCCODE:=P_AMCCODE;
        end if;
    v_FromDate  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    BEGIN
        SELECT EA.VND INTO V_EXCHANGERATE
        FROM EXCHANGERATE_ORTHER EA,
        (
            SELECT CURRENCY, MAX(TRADEDATE) TRADEDATE
            FROM EXCHANGERATE_ORTHER
            WHERE TRADEDATE <= v_FromDate
            AND CURRENCY = 'USD'
            GROUP BY CURRENCY
        )EB
        WHERE EA.CURRENCY = EB.CURRENCY AND EA.TRADEDATE = EB.TRADEDATE;
    EXCEPTION
        WHEN OTHERS  THEN
            V_EXCHANGERATE := 1;
            plog.error ('CA600601: '||'TY GIA USD/VND NGAY '||v_FromDate||' KHONG TON TAI!!!');
    END;
-----------------------------------------------------------------------------------------------------------------------------------
OPEN PV_REFCURSOR FOR
    WITH SE_INF_HIST AS (
         SELECT SEH1.CODEID, CASE WHEN SB.TRADEPLACE ='003' THEN SEH1.BASICPRICE ELSE SEH1.CLOSEPRICE END CLOSEPRICE
            , SEH1.AVGPRICE
            FROM (
                SELECT CODEID, HISTDATE, CLOSEPRICE,BASICPRICE, AVGPRICE FROM VW_SECURITIES_INFO_HIST
                WHERE HISTDATE <= v_FromDate AND BASICPRICE > 0
            ) SEH1,(
                SELECT CODEID, MAX(HISTDATE) HISTDATE FROM VW_SECURITIES_INFO_HIST
                WHERE HISTDATE <= v_FromDate AND BASICPRICE > 0 GROUP BY CODEID
            ) SEH2,SBSECURITIES SB
            WHERE SEH1.CODEID = SEH2.CODEID
            AND SEH1.HISTDATE = SEH2.HISTDATE
            AND SEH1.CODEID = SB.CODEID
    ),
    EX_OTH AS (
        SELECT EA.CURRENCY, EA.VND
        FROM EXCHANGERATE_ORTHER EA,
        (
            SELECT CURRENCY, MAX(TRADEDATE) TRADEDATE
            FROM EXCHANGERATE_ORTHER
            WHERE TRADEDATE <= v_FromDate
            GROUP BY CURRENCY
        )EB
        WHERE EA.CURRENCY = EB.CURRENCY AND EA.TRADEDATE = EB.TRADEDATE
    )
    --==========================================MAIN SELECT QUERY=======================================================================
    SELECT ROW_NUMBER() OVER(ORDER BY UPPER(CF.FULLNAME)) No,
           FA.FULLNAME AMCName,
           CF.CIFID CIF,
           CF.FULLNAME FUNDName,
           CT.MARKET_VALUE_VND AUC_VND,
           CT.MARKET_VALUE_USD AUC_USD,
           ROUND(CT.MARKET_VALUE_USD/1000,15) AUC_THOUSANDUSD
    FROM (
        SELECT A.CUSTID, SUM(A.MARKET_VALUE_VND) MARKET_VALUE_VND, SUM(A.MARKET_VALUE_USD) MARKET_VALUE_USD
        FROM (
            SELECT SU.CUSTID, SU.CURRENCY
                 , ROUND(SUM(AMT) * (CASE WHEN SU.CURRENCY = 'VND' THEN 1 ELSE V_EXCHANGERATE END), 2) MARKET_VALUE_VND
                 , ROUND(SUM(AMT) * (CASE WHEN SU.CURRENCY = 'VND' THEN V_EXCHANGERATE ELSE 1 END), 2) MARKET_VALUE_USD
            FROM (
                SELECT SE.CUSTID , SB.CURRENCY, SUM((SE.TRADE + SE.NETTING + SE.BLOCKED - NVL(TR.NAMT,0)) * NVL((
                    CASE WHEN SB.SECTYPE IN ('001','002','008') AND SB.TRADEPLACE IN ('001','002','010') THEN SI.CLOSEPRICE
                         WHEN SB.SECTYPE IN ('001','002','008') AND SB.TRADEPLACE IN ('005') THEN SI.AVGPRICE
                         WHEN SB.SECTYPE IN ('001','002') AND SB.TRADEPLACE IN ('003') THEN SI.CLOSEPRICE -- Thoai.tran 01/05/2021 SHBVNEX-1734
                         ELSE SB.PARVALUE END
                ),0)) AMT
                FROM SEMAST SE
                JOIN (
                    SELECT SB.CODEID, SB.SECTYPE, SB.SYMBOL, SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL, SB.EXPDATE, SB.PARVALUE, SC.SHORTCD CURRENCY, (CASE WHEN SB.REFCODEID IS NULL THEN SB.TRADEPLACE ELSE SB1.TRADEPLACE END) TRADEPLACE
                    FROM SBSECURITIES SB, SBSECURITIES SB1, SBCURRENCY SC
                    WHERE SB.REFCODEID = SB1.CODEID(+)
                    AND SB.SECTYPE NOT IN ('000','111','222','333','444','555')
                    AND SC.CCYCD = SB.CCYCD
                ) SB ON SB.CODEID = SE.CODEID
                LEFT JOIN SE_INF_HIST SI ON SI.CODEID = (CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
                LEFT JOIN (
                    SELECT CUSTODYCD, ACCTNO, SYMBOL, BUSDATE, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                    FROM VW_SETRAN_GEN
                    WHERE FIELD IN ('TRADE','NETTING','BLOCKED') AND BUSDATE > v_FromDate
                    GROUP BY CUSTODYCD, ACCTNO, SYMBOL, BUSDATE
                ) TR ON SE.ACCTNO = TR.ACCTNO
                WHERE SE.CUSTID IS NOT NULL
                GROUP BY SE.CUSTID, SB.CURRENCY
            )SU
            GROUP BY SU.CUSTID, SU.CURRENCY

            UNION ALL

            SELECT TM.CUSTID, TM.CURRENCY
                 , ROUND(SUM(TM.AMT) * (CASE WHEN TM.CURRENCY = 'VND' THEN 1 ELSE V_EXCHANGERATE END),2) MARKET_VALUE_VND
                 , ROUND(SUM(TM.AMT) / (CASE WHEN TM.CURRENCY = 'VND' THEN V_EXCHANGERATE ELSE 1 END),2) MARKET_VALUE_USD
            FROM(
                SELECT DD.CUSTID, DD.CCYCD CURRENCY, SUM((DD.BALANCE - NVL(TR.NAMT,0)) * (CASE WHEN DD.CCYCD <> 'VND' THEN EX.VND ELSE 1 END)) AMT
                FROM DDMAST DD
                LEFT JOIN (
                    SELECT ACCTNO, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                    FROM VW_DDTRAN_GEN
                    WHERE FIELD IN ('BALANCE') AND BUSDATE > v_FromDate
                    GROUP BY ACCTNO
                ) TR ON DD.ACCTNO = TR.ACCTNO
                LEFT JOIN EX_OTH EX ON EX.CURRENCY = DD.CCYCD
                GROUP BY DD.CUSTID, DD.CCYCD
            )TM
            GROUP BY TM.CUSTID, TM.CURRENCY
        ) A
        GROUP BY CUSTID
    ) CT
    JOIN CFMAST CF ON CF.CUSTID = CT.CUSTID AND CF.STATUS <> 'C' AND CF.CUSTATCOM ='Y' --LUU KY TAI SHINHAN
    JOIN FAMEMBERS FA ON FA.AUTOID = CF.AMCID AND FA.ROLES='AMC'
    WHERE NVL(FA.SHORTNAME,'x') LIKE v_AMCCODE
    ORDER BY CF.FULLNAME;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CA600601: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
