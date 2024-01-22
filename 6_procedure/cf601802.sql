SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CF601802 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   I_DATE                 IN VARCHAR2,
   PV_CUSTODYCD           IN       VARCHAR2 /*SO TK LUU KY */
   )
IS
    -- BANK CONFIRMATION - SECURITY
    -- PERSON      DATE                 COMMENTS
    -- ---------   ------               -------------------------------------------
    -- NAM.LY    24-12-2019           CREATED
    V_STROPTION    VARCHAR2 (5);
    V_STRBRID      VARCHAR2 (4);
    V_CUSTODYCD    VARCHAR2(20);
    V_REPORT_DATE DATE;
BEGIN
    V_STROPTION := OPT;
    V_REPORT_DATE  :=  TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:=BRID;
    END IF;
    V_CUSTODYCD := REPLACE(PV_CUSTODYCD,'.','');
OPEN PV_REFCURSOR FOR
             WITH TMP_SB AS ( --BANG TAM SB
                                    SELECT SB.CODEID, SB.SECTYPE, SB.SYMBOL, SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL, SB.EXPDATE, SB.PARVALUE
                                          , (CASE WHEN SB.REFCODEID IS NULL THEN SB.ISINCODE ELSE SB1.ISINCODE END) ISINCODE
                                          , (CASE WHEN SB.REFCODEID IS NULL THEN SB.TRADEPLACE ELSE SB1.TRADEPLACE END) TRADEPLACE
                                    FROM SBSECURITIES SB, SBSECURITIES SB1
                                    WHERE SB.REFCODEID = SB1.CODEID(+) AND SB.SECTYPE <> '004'
                                  )
                       , TMP_TR AS ( --BANG TEMP TR
                                     SELECT CUSTODYCD, ACCTNO, SYMBOL, BUSDATE, FIELD, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT,
                                            (CASE WHEN FIELD IN ('HOLD','NETTING') THEN 'HLD' ELSE
                                             CASE WHEN FIELD IN ('BLOCKED','WITHDRAW','BLOCKWITHDRAW') AND SYMBOL NOT LIKE '%_WFT' THEN 'BLO' ELSE
                                             CASE WHEN FIELD IN ('TRADE','BLOCKED') AND SYMBOL LIKE '%_WFT' THEN 'SEG' ELSE
                                             CASE WHEN FIELD IN ('TRADE') AND SYMBOL NOT LIKE '%_WFT' THEN 'AVL' ELSE
                                             CASE WHEN FIELD IN ('RECEIVING') AND SYMBOL NOT LIKE '%_WFT' THEN 'REC' ELSE
                                             CASE WHEN FIELD IN ('BLOCKED','WITHDRAW','BLOCKWITHDRAW') AND SYMBOL LIKE '%_WFT' THEN 'WFTR' ELSE
                                             CASE WHEN FIELD IN ('TRADE') AND SYMBOL LIKE '%_WFT' THEN 'WFTF'
                                             END END END END END END END) STATUS
                                     FROM VW_SETRAN_GEN
                                     WHERE BUSDATE > V_REPORT_DATE AND FIELD IN ('HOLD','NETTING','BLOCKED','TRADE','WITHDRAW','RECEIVING','BLOCKWITHDRAW')
                                     GROUP BY CUSTODYCD, ACCTNO, SYMBOL, BUSDATE, FIELD
                                   )
                       , TMP_DD AS ( --BANG TEMP TR
                                     SELECT ACCTNO, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                                     FROM VW_DDTRAN_GEN
                                     WHERE FIELD IN ('BALANCE') AND BUSDATE > V_REPORT_DATE
                                     GROUP BY ACCTNO
                                    )
                       , TMP_SI AS ( --BANG TAM GIA BASICPRICE
                                    SELECT CODEID, BASICPRICE
                                    FROM VW_SECURITIES_INFO_HIST
                                    WHERE (CODEID,HISTDATE) IN (
                                                                 SELECT CODEID, MAX(HISTDATE)
                                                                 FROM VW_SECURITIES_INFO_HIST
                                                                 WHERE HISTDATE <= V_REPORT_DATE
                                                                 GROUP BY CODEID
                                                               )
                                     )
                       , TMP_SURPLUS AS ( --BANG TEMP TINH SO DU CHUNG KHOAN
                                         SELECT CUSTID,ACCTNO,TRADEPLACE,STATUS,SYMBOL,ISINCODE,MARKET_PRICE,SUM(TOTAL)TOTAL
                                         FROM (
                                                 SELECT SE.CUSTID
                                                        ,SE.ACCTNO
                                                        ,SB.TRADEPLACE
                                                        ,SB.ISINCODE
                                                        ,(CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END) SYMBOL
                                                        ,SUM(SE.HOLD + SE.NETTING) TOTAL_HLD
                                                        ,(CASE WHEN SB.REFSYMBOL IS NULL THEN SUM(SE.TRADE) ELSE 0 END) TOTAL_AVL
                                                        ,(CASE WHEN SB.REFSYMBOL IS NULL THEN SUM(SE.RECEIVING) ELSE 0 END) TOTAL_SEC
                                                        ,(CASE WHEN SB.REFSYMBOL IS NULL THEN 0 ELSE SUM(SE.TRADE + SE.BLOCKED) END) TOTAL_SEG
                                                        ,(CASE WHEN SB.REFSYMBOL IS NULL THEN SUM(SE.BLOCKED + SE.WITHDRAW + SE.BLOCKWITHDRAW) ELSE 0 END) TOTAL_BLO
                                                        ,(CASE WHEN SB.REFSYMBOL IS NULL THEN 0 ELSE SUM(SE.TRADE) END) TOTAL_WFTF
                                                        ,(CASE WHEN SB.REFSYMBOL IS NULL THEN 0 ELSE SUM(SE.BLOCKED + SE.WITHDRAW + SE.BLOCKWITHDRAW) END) TOTAL_WFTR
                                                        ,(CASE WHEN SB.SECTYPE IN ('001','002') AND SB.TRADEPLACE IN ('001','002','005') THEN SI.BASICPRICE ELSE SB.PARVALUE END) MARKET_PRICE
                                                 FROM SEMAST SE JOIN TMP_SB SB ON SB.CODEID = SE.CODEID
                                                                JOIN TMP_SI SI ON SI.CODEID = (CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
                                                 WHERE SE.CUSTID IS NOT NULL
                                                 GROUP BY SE.CUSTID
                                                         ,SE.ACCTNO
                                                         ,SB.TRADEPLACE
                                                         ,SB.ISINCODE
                                                         ,(CASE WHEN SB.SECTYPE IN ('001','002') AND SB.TRADEPLACE IN ('001','002','005') THEN SI.BASICPRICE ELSE SB.PARVALUE END)
                                                         ,SB.REFSYMBOL
                                                         ,(CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END)
                                               )
                                         UNPIVOT (
                                                TOTAL
                                                FOR STATUS IN (
                                                                TOTAL_AVL  AS 'AVL',
                                                                TOTAL_SEG  AS 'SEG',
                                                                TOTAL_HLD  AS 'HLD',
                                                                TOTAL_BLO  AS 'BLO',
                                                                TOTAL_SEC  AS 'REC',
                                                                TOTAL_WFTF AS 'WFTF',
                                                                TOTAL_WFTR AS 'WFTR'
                                                              )
                                                )
                                         GROUP BY CUSTID,ACCTNO,TRADEPLACE,STATUS,SYMBOL,MARKET_PRICE,ISINCODE
                                        )
                       , TMP_CK AS ( --BANG TEMP CHUNG KHOAN
                                        SELECT SU.CUSTID
                                            , SU.SYMBOL
                                            , SU.STATUS
                                            , SU.ISINCODE
                                            , SUM(SU.TOTAL - NVL(TR.NAMT,0)) QUANTITY
                                            , (CASE WHEN SU.TRADEPLACE IN ('001','002','005') THEN 'Listed and UpCOM'  --CHUNG KHOAN NIEM YET : TRADEPLACE = HNX, UPCOM, HOSE
                                               ELSE 'Unlisted' END) SECURITIES_TYPE
                                            , SU.MARKET_PRICE
                                        FROM TMP_SURPLUS SU LEFT JOIN TMP_TR TR ON SU.ACCTNO = TR.ACCTNO AND SU.STATUS = TR.STATUS
                                        GROUP BY SU.CUSTID, SU.STATUS, SU.MARKET_PRICE, SU.SYMBOL, SU.TRADEPLACE, SU.ISINCODE
                                   )
            --==========================================MAIN SELECT QUERY=======================================================================
                SELECT SUBSTR(CF.CIFID,1,3) || '-' || SUBSTR(CF.CIFID,4,3) || SUBSTR(CF.CIFID,7,6) ACCOUNT_NUMBER
                     , CF.FULLNAME ACCOUNT_NAME
                     , CK.SYMBOL
                     , CK.ISINCODE
                     , CK.STATUS
                     , CK.QUANTITY FACE_AMT
                     , CK.SECURITIES_TYPE SECTYPE
                     , CK.MARKET_PRICE REFPRICE
                FROM TMP_CK CK JOIN CFMAST CF ON CF.CUSTID = CK.CUSTID
                WHERE CK.QUANTITY <> 0
                      AND CF.CUSTODYCD = V_CUSTODYCD
                ORDER BY UPPER(CF.FULLNAME),CK.SYMBOL,CK.STATUS;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('CF601802: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
