SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd602001(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_AMCCODE              IN       VARCHAR2, /* Ma AMC */
   P_CLIENTGR             IN       VARCHAR2, /*Loai KH 1,2,3,ALL */
   PV_TXNUM               IN       VARCHAR2 /*SO CHUNG TU*/
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- NAM.LY     13-12-2019           CREATED
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
--
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
--
    v_tltitle          varchar2(200);
    v_tlfullname       varchar2(200);
    v_ExchangeRate     number;
    v_AMCCODE          varchar2(20);
    V_CIFID            varchar2(200);
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
------------------------------------RIT-----------------------------------------
    if P_AMCCODE='ALL' then
        v_AMCCODE:='%';
    else
    v_AMCCODE:=P_AMCCODE;
    end if;
--------------------------------------------------------------------------------
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
    WHEN OTHERS THEN
        V_EXCHANGERATE := 1;
        
    END;
    --
------------------------------------------------------------------------------------------------------------------------------------
    OPEN PV_REFCURSOR FOR
    WITH SE_INF_HIST AS (
        SELECT SEH1.CODEID, (CASE WHEN SB.TRADEPLACE ='003' AND SB.DEPOSITORY <> '001' AND SB.ISSEDEPOFEE = 'N' THEN SEH1.BASICPRICE ELSE SEH1.CLOSEPRICE END) CLOSEPRICE,
               SEH1.AVGPRICE
        FROM (
            SELECT CODEID, HISTDATE, CLOSEPRICE, BASICPRICE, AVGPRICE
            FROM VW_SECURITIES_INFO_HIST
            WHERE HISTDATE <= V_FROMDATE
            AND HISTDATE >= V_FROMDATE - 90
            AND BASICPRICE > 0
        ) SEH1,(
            SELECT CODEID, MAX(HISTDATE) HISTDATE
            FROM VW_SECURITIES_INFO_HIST
            WHERE HISTDATE <= V_FROMDATE
            AND HISTDATE >= V_FROMDATE - 90
            AND BASICPRICE > 0
            GROUP BY CODEID
        ) SEH2, SBSECURITIES SB
        WHERE SEH1.CODEID = SEH2.CODEID
        AND SEH1.HISTDATE = SEH2.HISTDATE
        AND SEH1.CODEID = SB.CODEID
    )
    --==========================================MAIN SELECT QUERY=======================================================================
    SELECT A.*,ROW_NUMBER() OVER (ORDER BY A.AMC_NAME,A.PORTFOLIO_NUMBER)  NO
    FROM (
        SELECT
               CF.CIFID PORTFOLIO_NUMBER
             , FA.FULLNAME AMC_NAME
             , CF.FULLNAME FUND_NAME
             , SUM(CT.MARKET_PRICE) MARKET_PRICE
             , ROUND(SUM(CT.MARKET_VALUE_VND),10) MARKET_VALUE_VND
             , ROUND(SUM(CT.MARKET_VALUE_USD),10) MARKET_VALUE_USD
             , ROUND(SUM(CT.MARKET_VALUE_USD/1000),10) MARKET_VALUE_USD_THOU
             , CF.MCIFID
        FROM (
                SELECT CK.*, 'CK' TYPE
                FROM (
                    --BANG TEMP CHUNG KHOAN
                    SELECT SU.CUSTID
                        , SU.SYMBOL SECURITIES_ID
                        , SU.STATUS SECURITIES_STATUS
                        , SUM(SU.TOTAL - NVL(TR.NAMT,0)) QUANTITY
                        , SU.CURRENCY
                        , SU.MARKET_PRICE
                        , ROUND(SUM(SU.TOTAL - NVL(TR.NAMT,0)) * SU.MARKET_PRICE * (CASE WHEN SU.CURRENCY = 'VND' THEN 1 ELSE V_EXCHANGERATE END), 15) MARKET_VALUE_VND
                        , ROUND(SUM(SU.TOTAL - NVL(TR.NAMT,0)) * SU.MARKET_PRICE / (CASE WHEN SU.CURRENCY = 'VND' THEN V_EXCHANGERATE ELSE 1 END), 15) MARKET_VALUE_USD
                    FROM (
                        --BANG TEMP TINH SO DU CHUNG KHOAN
                         SELECT CUSTID,ACCTNO,SECTYPE,STATUS,SYMBOL,MARKET_PRICE,CURRENCY,SUM(TOTAL)TOTAL
                         FROM (
                            SELECT SE.CUSTID
                                    ,SE.ACCTNO
                                    ,SB.SECTYPE
                                    ,SB.CURRENCY
                                    ,(CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END) SYMBOL
                                    , SUM(SE.NETTING + SE.WITHDRAW +SE.BLOCKWITHDRAW) TOTAL_HLD
                                    ,(CASE WHEN SB.REFSYMBOL IS NULL THEN SUM(SE.TRADE + SE.HOLD) ELSE 0 END) TOTAL_AVL
                                    ,(CASE WHEN SB.REFSYMBOL IS NULL THEN 0 ELSE SUM(SE.TRADE + SE.BLOCKED) END) TOTAL_SEG
                                    ,(CASE WHEN SB.REFSYMBOL IS NULL THEN SUM(SE.BLOCKED + SE.MORTAGE) ELSE 0 END) TOTAL_BLO
                                    ,NVL((
                                        CASE WHEN SB.SECTYPE IN ('008','011','001','002') THEN (CASE WHEN NVL(SI.CLOSEPRICE,0) > 0 THEN SI.CLOSEPRICE ELSE SB.PARVALUE END)
                                             ELSE SB.PARVALUE END
                                     ),0) MARKET_PRICE
                            FROM SEMAST SE
                            JOIN (
                                --BANG TAM SB
                                SELECT SB.CODEID, SB.SECTYPE, SB.SYMBOL, SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL, SB.EXPDATE, SB.PARVALUE, SC.SHORTCD CURRENCY, (CASE WHEN SB.REFCODEID IS NULL THEN SB.TRADEPLACE ELSE SB1.TRADEPLACE END) TRADEPLACE
                                FROM SBSECURITIES SB, SBSECURITIES SB1, SBCURRENCY SC
                                WHERE SB.REFCODEID = SB1.CODEID(+)
                                AND SB.SECTYPE NOT IN ('000','111','222','333','444','555','004')
                                AND SC.CCYCD = SB.CCYCD
                            ) SB ON SB.CODEID = SE.CODEID
                            LEFT JOIN SE_INF_HIST SI ON SI.CODEID = (CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
                            WHERE SE.CUSTID IS NOT NULL
                            GROUP BY SE.CUSTID, SE.ACCTNO, SB.SECTYPE, SB.REFSYMBOL, SB.CURRENCY,
                            (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END),
                            NVL((
                                CASE WHEN SB.SECTYPE IN ('008','011','001','002') THEN (CASE WHEN NVL(SI.CLOSEPRICE,0) > 0 THEN SI.CLOSEPRICE ELSE SB.PARVALUE END)
                                     ELSE SB.PARVALUE END
                            ),0)
                        )
                        UNPIVOT (
                            TOTAL FOR STATUS IN (
                                TOTAL_AVL AS 'AVL',
                                TOTAL_SEG AS 'SEG',
                                TOTAL_HLD AS 'HLD',
                                TOTAL_BLO AS 'BLO'
                            )
                        )
                        GROUP BY CUSTID,ACCTNO,SECTYPE,STATUS,SYMBOL,MARKET_PRICE,CURRENCY
                  ) SU
                 LEFT JOIN ( --BANG TEMP TR
                     SELECT CUSTODYCD, ACCTNO, SYMBOL, FIELD, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT,
                            (CASE WHEN FIELD IN ('NETTING','WITHDRAW','BLOCKWITHDRAW') AND SYMBOL NOT LIKE '%_WFT' THEN 'HLD' ELSE
                             CASE WHEN FIELD IN ('BLOCKED','MORTAGE') AND SYMBOL NOT LIKE '%_WFT' THEN 'BLO' ELSE
                             CASE WHEN FIELD IN ('TRADE','BLOCKED') AND SYMBOL LIKE '%_WFT' THEN 'SEG' ELSE
                             CASE WHEN FIELD IN ('TRADE','HOLD') AND SYMBOL NOT LIKE '%_WFT' THEN 'AVL'
                             END END END END) STATUS
                     FROM VW_SETRAN_GEN
                     WHERE BUSDATE > v_FromDate AND FIELD IN ('HOLD','NETTING','BLOCKED','TRADE','WITHDRAW','BLOCKWITHDRAW','MORTAGE')
                     GROUP BY CUSTODYCD, ACCTNO, SYMBOL, FIELD
                   ) TR ON SU.ACCTNO = TR.ACCTNO AND SU.STATUS = TR.STATUS
                   GROUP BY SU.CUSTID, SU.SECTYPE, SU.STATUS, SU.MARKET_PRICE, SU.SYMBOL, SU.CURRENCY
               ) CK
                --WHERE CK.MARKET_VALUE_VND <> 0
                UNION ALL----------------------------------------------------------------------------------------------------
                SELECT TM.CUSTID
                     , TM.ACCOUNTTYPE SECURITIES_ID
                     , '' SECURITIES_STATUS
                     , 0 QUANTITY
                     , TM.CURRENCY
                     , 0 MARKET_PRICE
                     , TM.MARKET_VALUE_VND
                     , TM.MARKET_VALUE_USD
                     , 'TM' TYPE
                FROM (
                    --BANG TEMP TIEN MAT
                    SELECT DD.CUSTID
                        , DD.ACCOUNTTYPE
                        , DD.CCYCD CURRENCY
                        , DD.REFCASAACCT
                        , ROUND((DD.BALANCE - NVL(TR.NAMT,0)) * (CASE WHEN DD.CCYCD = 'VND' THEN 1 ELSE V_EXCHANGERATE END),15) MARKET_VALUE_VND
                        , ROUND((DD.BALANCE - NVL(TR.NAMT,0)) / (CASE WHEN DD.CCYCD = 'VND' THEN V_EXCHANGERATE ELSE 1 END),15) MARKET_VALUE_USD
                    FROM DDMAST DD
                    LEFT JOIN (
                        --BANG TEMP TR
                         SELECT ACCTNO, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                         FROM VW_DDTRAN_GEN
                         WHERE FIELD IN ('BALANCE') AND BUSDATE > v_FromDate
                         GROUP BY ACCTNO
                    ) TR ON DD.ACCTNO = TR.ACCTNO
                ) TM
                --WHERE TM.MARKET_VALUE_VND <> 0
        ) CT
        JOIN CFMAST CF ON CF.CUSTID = CT.CUSTID
                       AND CF.STATUS <> 'C'
                       AND CF.CUSTATCOM ='Y'
                       AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
                                 WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
                                 WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
                                 WHEN P_CLIENTGR = 'ALL' THEN 1
                                 ELSE 0 END) = 1
        LEFT JOIN FAMEMBERS FA ON FA.AUTOID = CF.AMCID AND FA.ROLES= 'AMC'
        WHERE NVL(FA.SHORTNAME,'x') LIKE v_AMCCODE
        GROUP BY CF.CIFID, FA.FULLNAME, CF.FULLNAME, CF.MCIFID
    )A
    ORDER BY AMC_NAME,PORTFOLIO_NUMBER;
EXCEPTION
WHEN OTHERS THEN
    PLOG.ERROR ('DD602001: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN;

END;
/
