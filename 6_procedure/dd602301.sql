SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE dd602301(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   PV_CUSTODYCD              IN       VARCHAR2
   )
IS
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
    v_beginamt      number;
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
    v_CustodyCD:=Replace(PV_CUSTODYCD,'.','');
--------------------------------------------------------------------------------
    v_FromDate  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    BEGIN
        SELECT EA.VND INTO V_EXCHANGERATE
        FROM EXCHANGERATE_ORTHER EA,
        (
            SELECT CURRENCY, MAX(TRADEDATE) TRADEDATE
            FROM EXCHANGERATE_ORTHER
            WHERE TRADEDATE <= v_ToDate
            AND CURRENCY = 'USD'
            GROUP BY CURRENCY
        )EB
        WHERE EA.CURRENCY = EB.CURRENCY AND EA.TRADEDATE = EB.TRADEDATE;
    EXCEPTION
    WHEN OTHERS THEN
        V_EXCHANGERATE := 1;
        
    END;

    BEGIN
            SELECT SUM(MARKET_VALUE_VND) into v_beginamt
        FROM (
        --==========================================MAIN SELECT QUERY=======================================================================
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
                 , CT.REFCASAACCT
            FROM (
                    SELECT CK.*, 'CK' TYPE,'' REFCASAACCT
                    FROM ( --BANG TEMP CHUNG KHOAN
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
                        FROM ( --BANG TEMP TINH SO DU CHUNG KHOAN
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
                                LEFT JOIN (
                                        SELECT SEH1.CODEID, (CASE WHEN SB.TRADEPLACE ='003' AND SB.DEPOSITORY <> '001' AND SB.ISSEDEPOFEE = 'N' THEN SEH1.BASICPRICE ELSE SEH1.CLOSEPRICE END) CLOSEPRICE,
                                               SEH1.AVGPRICE
                                        FROM (
                                            SELECT CODEID, HISTDATE, CLOSEPRICE, BASICPRICE, AVGPRICE FROM VW_SECURITIES_INFO_HIST WHERE HISTDATE <= v_FromDate AND BASICPRICE > 0
                                        ) SEH1,(
                                            SELECT CODEID, MAX(HISTDATE) HISTDATE FROM VW_SECURITIES_INFO_HIST WHERE HISTDATE <= v_FromDate AND BASICPRICE > 0 GROUP BY CODEID
                                        ) SEH2, SBSECURITIES SB
                                        WHERE SEH1.CODEID = SEH2.CODEID
                                        AND SEH1.HISTDATE = SEH2.HISTDATE
                                        AND SEH1.CODEID = SB.CODEID
                                    ) SI ON SI.CODEID = (CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
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
                            SELECT CUSTODYCD, ACCTNO, SYMBOL, STATUS, SUM(NAMT) NAMT
                            FROM (
                                SELECT CUSTODYCD, ACCTNO, SYMBOL, FIELD, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT,
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
                    UNION ALL
                    SELECT TM.CUSTID
                         , TM.ACCOUNTTYPE SECURITIES_ID
                         , '' SECURITIES_TYPE
                         , '' SECURITIES_STATUS
                         , 0 QUANTITY
                         , TM.CURRENCY
                         , 0 MARKET_PRICE
                         , TM.MARKET_VALUE_VND
                         , TM.MARKET_VALUE_USD
                         , 'TM' TYPE
                         ,TM.REFCASAACCT
                    FROM
                        ( --BANG TEMP TIEN MAT
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
                    WHERE TM.MARKET_VALUE_VND <> 0
             ) CT
             JOIN CFMAST CF ON CF.CUSTID = CT.CUSTID
                            AND CF.STATUS <> 'C'
                            AND CF.CUSTATCOM = 'Y' --LUU KY TAI SHINHAN
                            AND CF.CUSTODYCD LIKE v_CustodyCD
             LEFT JOIN FAMEMBERS FA ON FA.AUTOID = CF.AMCID AND FA.ROLES = 'AMC'
        )
        ORDER BY TYPE, UPPER(PORTFOLIO_NAME), SECURITIES_ID, SECURITIES_STATUS;

    EXCEPTION WHEN OTHERS THEN
        v_beginamt := 0;
    END;
------------------------------------------------------------------------------------------------------------------------------------
    OPEN PV_REFCURSOR FOR
    select CUSTODYCD, AFACCTNO, SYMBOL,CODEID, BUSDATE,TXNUM TLTXCD,TXDESC,TXTYPE,REFCASAACCT,CCYCD,
            NVL(CASE WHEN TYPE='CK' THEN CASE WHEN TXTYPE ='C' then QTTY ELSE 0 END ELSE 0 END,0) C_QTTY,
            NVL(CASE WHEN TYPE='CK' THEN CASE WHEN TXTYPE ='C' then NAMT ELSE 0 END ELSE 0 END,0) C_NAMT,
            NVL(CASE WHEN TYPE='CK' THEN CASE WHEN TXTYPE ='C' then 0 ELSE QTTY END ELSE 0 END,0) D_QTTY,
            NVL(CASE WHEN TYPE='CK' THEN CASE WHEN TXTYPE ='C' then 0 ELSE NAMT END ELSE 0 END,0) D_NAMT,
            NVL(CASE WHEN TYPE='DD' THEN CASE WHEN TXTYPE ='C' then NAMT ELSE 0 END ELSE 0 END,0) C_DDNAMT,
            NVL(CASE WHEN TYPE='DD' THEN CASE WHEN TXTYPE ='C' then 0 ELSE NAMT END ELSE 0 END,0) D_DDNAMT,
            0 TOTAL_VND,
            0 TOTAL_USD,
            nvl(v_beginamt,0) BEGIN_AMT_VND,
            nvl(round(v_beginamt/V_EXCHANGERATE,2),0) BEGIN_AMT_USD,
            1 VND_A,1 VND_B,1 USD_A,1 USD_B,
            V_EXCHANGERATE EXCHANGERATE
    from (
        SELECT distinct CUSTODYCD,AFACCTNO,REFCASAACCT,CCYCD,SYMBOL,CODEID,BUSDATE,TXNUM,TXDESC,TXTYPE,QTTY,
              (CASE WHEN CURRENCY = 'VND' THEN QTTY * MARKET_PRICE ELSE QTTY * MARKET_PRICE* V_EXCHANGERATE END ) NAMT,TYPE
        from (
            select A.*,NVL((CASE WHEN SB.SECTYPE IN ('008','011','001','002') THEN (CASE WHEN NVL(SI.CLOSEPRICE,0) > 0 THEN SI.CLOSEPRICE ELSE SB.PARVALUE END) ELSE SB.PARVALUE END),0) MARKET_PRICE, SB.CURRENCY
            from(
                SELECT DISTINCT custodycd,afacctno,'' refcasaacct,'' ccycd,symbol,codeid,busdate,txnum,txdesc,
                       CASE WHEN namt < 0 THEN 'D' ELSE 'C' END txtype,ABS (namt) qtty,'CK' TYPE
                FROM (
                    SELECT tr.tltxcd,tr.txnum,tr.txdate,tr.busdate,tr.custodycd,tr.afacctno,tr.symbol,tr.codeid,SUM (DECODE (txtype, 'C', namt, -namt)) namt,tr.txdesc
                    FROM vw_setran_gen tr
                    WHERE field IN ('TRADE','NETTING','WITHDRAW','BLOCKED','DTOCLOSE','BLOCKWITHDRAW','BLOCKDTOCLOSE','EMKQTTY','HOLD','MORTAGE')
                    --AND tr.tltxcd NOT IN ('1902', '1903', '2213')
                    AND custodycd = v_CustodyCD
                    AND busdate >= v_FromDate AND busdate <= v_ToDate
                    GROUP BY tr.tltxcd,tr.txnum,tr.txdate,tr.busdate,tr.custodycd,tr.afacctno,tr.txdesc,tr.symbol,tr.codeid
                    HAVING SUM (DECODE (txtype, 'C', namt, -namt)) <> 0
                )
            )A
            JOIN (
                SELECT SB.CODEID, SB.SECTYPE, SB.SYMBOL, SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL, SB.EXPDATE, SB.PARVALUE, SC.SHORTCD CURRENCY, (CASE WHEN SB.REFCODEID IS NULL THEN SB.TRADEPLACE ELSE SB1.TRADEPLACE END) TRADEPLACE
                FROM SBSECURITIES SB, SBSECURITIES SB1, SBCURRENCY SC
                WHERE SB.REFCODEID = SB1.CODEID(+)
                AND SB.SECTYPE NOT IN ('000','111','222','333','444','555','004')
                AND SC.CCYCD = SB.CCYCD
            ) SB ON SB.CODEID = A.CODEID
            LEFT JOIN (
                SELECT SEH1.CODEID, (CASE WHEN SB.TRADEPLACE ='003' AND SB.DEPOSITORY <> '001' AND SB.ISSEDEPOFEE = 'N' THEN SEH1.BASICPRICE ELSE SEH1.CLOSEPRICE END) CLOSEPRICE, SEH1.AVGPRICE
                FROM
                (
                    SELECT CODEID, HISTDATE, CLOSEPRICE, BASICPRICE, AVGPRICE FROM VW_SECURITIES_INFO_HIST WHERE HISTDATE <= v_ToDate AND BASICPRICE > 0
                ) SEH1,
                (
                    SELECT CODEID, MAX(HISTDATE) HISTDATE FROM VW_SECURITIES_INFO_HIST WHERE HISTDATE <= v_ToDate AND BASICPRICE > 0 GROUP BY CODEID
                ) SEH2, SBSECURITIES SB
                WHERE SEH1.CODEID = SEH2.CODEID
                AND SEH1.HISTDATE = SEH2.HISTDATE
                AND SEH1.CODEID = SB.CODEID
            ) SI ON SI.CODEID = (CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END))
            union all
            --BANG TEMP TR
            SELECT distinct TR.CUSTODYCD,DD.AFACCTNO,DD.REFCASAACCT,DD.CCYCD,
                    '' SYMBOL,'' CODEID,TR.BUSDATE,TR.TXNUM,
                    TR.TXDESC,TR.TXTYPE,0 QTTY,CASE WHEN DD.CCYCD ='VND' THEN NAMT ELSE NAMT * V_EXCHANGERATE END NAMT,'DD' TYPE
            FROM VW_DDTRAN_GEN TR, ddmast dd
            WHERE TR.FIELD IN ('BALANCE') AND BUSDATE >= v_FromDate AND BUSDATE <= v_ToDate
            and TR.acctno=DD.ACCTNO
            and dd.custodycd=v_CustodyCD
        ) ORDER BY BUSDATE;
EXCEPTION
WHEN OTHERS THEN
    PLOG.ERROR ('DD602301: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN;

END;
/
