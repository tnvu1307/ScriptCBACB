SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd602101(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   P_AMCCODE              IN       VARCHAR2, /* Ma AMC */
   P_CIFID                IN       VARCHAR2, /*Ma KH tai ngan hang */
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
    v_first_date_in_month date;
    v_end_work_date date;
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
------------------------------------RIT-----------------------------------------
    if P_CIFID ='ALL' then
        V_CIFID:='%';
    else
        V_CIFID:=P_CIFID;
    end if;
--------------------------------------------------------------------------------
    v_FromDate  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    --v_first_date_in_month := TO_DATE('01' || to_char(v_FromDate,'MM/RRRR'),'DD/MM/RRRR');
    --v_end_work_date := getprevdate(v_first_date_in_month, 1);
    BEGIN
        SELECT EB2.VND INTO V_EXCHANGERATE
        FROM
        (
            SELECT CURRENCY, ITYPE, RTYPE, MAX(LASTCHANGE) LASTCHANGE
            FROM (
                SELECT * FROM EXCHANGERATE
                UNION ALL
                SELECT * FROM EXCHANGERATE_HIST
            )
            WHERE TO_DATE(TO_CHAR(LASTCHANGE,'DD/MM/RRRR'),'DD/MM/RRRR') <= v_FromDate--TRADEDATE <= v_FromDate
            AND CURRENCY = 'USD'
            AND ITYPE = 'SHV'
            AND RTYPE = 'TTM'
            GROUP BY CURRENCY, ITYPE, RTYPE
        )EB1,
        (
            SELECT * FROM EXCHANGERATE
            UNION ALL
            SELECT * FROM EXCHANGERATE_HIST
        )EB2
        WHERE EB1.CURRENCY = EB2.CURRENCY
        AND EB1.ITYPE = EB2.ITYPE
        AND EB1.RTYPE = EB2.RTYPE
        AND EB1.LASTCHANGE = EB2.LASTCHANGE;
    EXCEPTION
    WHEN OTHERS  THEN
        V_EXCHANGERATE := 1;
        
    END;
    ------------------------------------------------------------------------------------------------------------------------------------

    OPEN PV_REFCURSOR FOR
        WITH SE_INF_HIST AS (
            SELECT SEH1.CODEID, SEH1.CLOSEPRICE, SEH1.AVGPRICE
            FROM (
                SELECT CODEID, HISTDATE, CLOSEPRICE, AVGPRICE
                FROM VW_SECURITIES_INFO_HIST
                WHERE HISTDATE <= V_FROMDATE
                AND HISTDATE >= V_FROMDATE - 90
            ) SEH1,(
                SELECT CODEID, MAX(HISTDATE) HISTDATE
                FROM VW_SECURITIES_INFO_HIST
                WHERE HISTDATE <= V_FROMDATE
                AND HISTDATE >= V_FROMDATE - 90
                GROUP BY CODEID
            ) SEH2
            WHERE SEH1.CODEID = SEH2.CODEID
            AND SEH1.HISTDATE = SEH2.HISTDATE
        )
        --==========================================MAIN SELECT QUERY=======================================================================
        SELECT A.*
            FROM (
                SELECT ROW_NUMBER() OVER (PARTITION BY CT.TYPE ORDER BY CT.TYPE,UPPER(CF.FULLNAME),CT.SECURITIES_ID,CT.SECURITIES_STATUS)  NO
                     , CF.CIFID PORTFOLIO_NUMBER
                     , CF.FULLNAME PORTFOLIO_NAME
                     , CT.SECURITIES_ID
                     , CT.SECURITIES_TYPE
                     , CT.SECURITIES_STATUS
                     , CT.QUANTITY
                     , CT.CURRENCY
                     , CT.MARKET_PRICE
                     , CT.MARKET_VALUE_VND
                     , CT.MARKET_VALUE_USD
                     , CT.TYPE
                     --, CF.MCUSTODYCD --TRUNG.LUU: 19-02-2021 SHBVNEX-2067 LAY TAI KHOAN ME
                      --TRUNG.LUU : 18-03-2021 SHBVNEX-2161  khong dung tai khoan me, dung master cifid
                      --trung.luu: 28-04-2021 SHBVNEX-2161 khong co mastercif thi de null
                     ,CF.MCIFID
                FROM (
                    SELECT CK.*, 'CK' TYPE
                    FROM (
                        --BANG TEMP CHUNG KHOAN
                        SELECT SU.CUSTID
                            , SU.SYMBOL SECURITIES_ID
                            , (CASE WHEN SU.SECTYPE IN ('001','002','008') THEN 'EQUITY' --CO PHIEU/CHUNG CHI QUY
                                        WHEN SU.SECTYPE IN ('003','006') THEN 'BOND' --TRAI PHIEU
                                        WHEN SU.SECTYPE = '013' THEN 'CD' --CHUNG CHI TIEN GUI
                                        WHEN SU.SECTYPE = '011' THEN 'CW' --CHUNG QUYEN
                                        WHEN SU.SECTYPE = '008' THEN 'FUCE'
                                        WHEN SU.SECTYPE = '009' THEN 'TD'
                                        WHEN SU.SECTYPE = '012' THEN 'T-Bill'
                                        WHEN SU.SECTYPE = '015' THEN 'Warrant'
                                        ELSE '' END
                              ) SECURITIES_TYPE
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
                                                CASE WHEN SB.SECTYPE IN ('001','002') AND SB.TRADEPLACE NOT IN ('003') THEN (CASE WHEN NVL(SI.CLOSEPRICE,0) > 0 THEN SI.CLOSEPRICE ELSE SB.PARVALUE END)
                                                     WHEN SB.SECTYPE IN ('008','011') THEN (CASE WHEN NVL(SI.CLOSEPRICE,0) > 0 THEN SI.CLOSEPRICE ELSE SB.PARVALUE END)
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
                                    CASE WHEN SB.SECTYPE IN ('001','002') AND SB.TRADEPLACE NOT IN ('003') THEN (CASE WHEN NVL(SI.CLOSEPRICE,0) > 0 THEN SI.CLOSEPRICE ELSE SB.PARVALUE END)
                                         WHEN SB.SECTYPE IN ('008','011') THEN (CASE WHEN NVL(SI.CLOSEPRICE,0) > 0 THEN SI.CLOSEPRICE ELSE SB.PARVALUE END)
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
                        LEFT JOIN (
                            --BANG TEMP TR
                            SELECT CUSTODYCD, ACCTNO, SYMBOL, STATUS, SUM(NAMT) NAMT
                            FROM
                            (     SELECT CUSTODYCD, ACCTNO, SYMBOL, FIELD, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT,
                                        (CASE WHEN FIELD IN ('NETTING','WITHDRAW','BLOCKWITHDRAW') AND SYMBOL NOT LIKE '%_WFT' THEN 'HLD' ELSE
                                         CASE WHEN FIELD IN ('BLOCKED','MORTAGE') AND SYMBOL NOT LIKE '%_WFT' THEN 'BLO' ELSE
                                         CASE WHEN FIELD IN ('TRADE','BLOCKED') AND SYMBOL LIKE '%_WFT' THEN 'SEG' ELSE
                                         CASE WHEN FIELD IN ('TRADE','HOLD') AND SYMBOL NOT LIKE '%_WFT' THEN 'AVL'
                                         END END END END) STATUS
                                 FROM VW_SETRAN_GEN
                                 WHERE BUSDATE > v_FromDate AND FIELD IN ('HOLD','NETTING','BLOCKED','TRADE','WITHDRAW','BLOCKWITHDRAW','MORTAGE')
                                 GROUP BY CUSTODYCD, ACCTNO, SYMBOL, FIELD
                            )
                            GROUP BY CUSTODYCD, ACCTNO, SYMBOL, STATUS
                        ) TR ON SU.ACCTNO = TR.ACCTNO AND SU.STATUS = TR.STATUS
                        GROUP BY SU.CUSTID, SU.SECTYPE, SU.STATUS, SU.MARKET_PRICE, SU.SYMBOL, SU.CURRENCY
                    ) CK
                    WHERE CK.MARKET_VALUE_VND <> 0
                ) CT
                JOIN CFMAST CF ON CF.CUSTID = CT.CUSTID
                               AND CF.STATUS <> 'C'
                               AND CF.CUSTATCOM ='Y'
                               AND CF.CIFID LIKE V_CIFID
                               AND (CASE WHEN P_CLIENTGR = '1' AND CF.BONDAGENT = 'Y' THEN 1
                                          WHEN P_CLIENTGR = '2' AND CF.SUPEBANK = 'Y' THEN 1
                                          WHEN P_CLIENTGR = '3' AND (CF.BONDAGENT = 'N' OR CF.SUPEBANK = 'N') THEN 1
                                          WHEN P_CLIENTGR = 'ALL' THEN 1
                                          ELSE 0 END) = 1
                LEFT JOIN FAMEMBERS FA ON FA.AUTOID = CF.AMCID AND FA.ROLES='AMC'
                WHERE NVL(FA.SHORTNAME,'x') LIKE v_AMCCODE
            )A--, CFMAST CF
            --WHERE A.MCUSTODYCD = CF.CUSTODYCD(+) --TRUNG.LUU: 19-02-2021 SHBVNEX-2067 LAY MASTER CIFID
        ORDER BY TYPE,UPPER(PORTFOLIO_NAME),SECURITIES_ID,SECURITIES_STATUS;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('DD602101: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;

End;
/
