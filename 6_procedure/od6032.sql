SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE OD6032(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,

   I_DATE                 IN       VARCHAR2, /*NGAY BAO CAO */
   PV_CUSTODYCD              IN       VARCHAR2, /* TKLK */
   PV_AMC                IN       VARCHAR2, /*AMC */
   PV_GCB             IN       VARCHAR2 /*GCB */
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- TRI.BUI     07/07/2020           CREATED
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    --
    V_IDATE            DATE;
    V_CURRDATE          DATE;
    V_CUSTODYCD         VARCHAR2(20);
    V_AMC            VARCHAR2(50);
    V_GCB          VARCHAR2(200);


BEGIN
     V_STROPTION := OPT;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;
    ------------------------------------
     V_CURRDATE   := GETCURRDATE;
     V_IDATE  := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
     V_CUSTODYCD := REPLACE(PV_CUSTODYCD,'.','');
    ------------------------------------
    IF UPPER(V_CUSTODYCD)='ALL' THEN
        V_CUSTODYCD:='%';
    ELSE
    V_CUSTODYCD:=V_CUSTODYCD;
    END IF;
    ------------------------------------
    IF UPPER(PV_AMC)='ALL' THEN
        V_AMC:='%';
    ELSE
        V_AMC:=PV_AMC;
    END IF;
    ------------------------------------
    IF UPPER(PV_GCB) ='ALL' THEN
        V_GCB:='%';
    ELSE
        V_GCB:=PV_GCB;
    END IF;
    ------------------------------------------------------------------------------------------------------------------------------------

    OPEN PV_REFCURSOR FOR
        WITH SE_INF_HIST AS (
            SELECT SEH1.CODEID, SEH1.CLOSEPRICE
            FROM (
                SELECT CODEID, HISTDATE, CLOSEPRICE, AVGPRICE FROM VW_SECURITIES_INFO_HIST WHERE HISTDATE = V_IDATE
            ) SEH1,(
                SELECT CODEID, MAX(HISTDATE) HISTDATE FROM VW_SECURITIES_INFO_HIST WHERE HISTDATE = V_IDATE  GROUP BY CODEID
            ) SEH2
            WHERE SEH1.CODEID = SEH2.CODEID
            AND SEH1.HISTDATE = SEH2.HISTDATE
        )
       SELECT *
        FROM (
        --==========================================MAIN SELECT QUERY=======================================================================
            SELECT
                   CF.FULLNAME
                 , CF.CUSTODYCD
                 , CT.SYMBOL
                 , CT.ISINCODE
                 , NVL(ISS.FULLNAME,CT.ISSUERID) AS TCPH--CASE WHEN SECURITIES_TYPE ='BOND' THEN CT.ISSUERID ELSE ISS.FULLNAME END AS TCPH
                 , CT.SECURITIES_TYPE
                 , CT.SECURITIES_STATUS
                 , CT.QUANTITY
                 , CT.CURRENCY
                 , CT.MARKET_PRICE
                 , TO_CHAR(V_IDATE,'DD/MM/RRRR') AS DATETIME
            FROM (
                    SELECT CK.*
                    FROM ( --BANG TEMP CHUNG KHOAN
                        SELECT SU.CUSTID
                            , SU.SYMBOL
                            , SU.ISINCODE
                            , SU.ISSUERID
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
                        FROM ( --BANG TEMP TINH SO DU CHUNG KHOAN
                             SELECT CUSTID,ACCTNO,SECTYPE,STATUS,SYMBOL,MARKET_PRICE,CURRENCY,ISINCODE,ISSUERID,SUM(TOTAL)TOTAL
                             FROM (
                                SELECT SE.CUSTID
                                        ,SE.ACCTNO
                                        ,SB.SECTYPE
                                        ,SB.CURRENCY
                                        ,SB.ISINCODE
                                        ,SB.ISSUERID
                                        ,(CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END) SYMBOL
                                        ,(CASE WHEN SB.REFSYMBOL IS NULL THEN SUM( SE.BLOCKED + SE.MORTAGE + SE.BLOCKTRANFER + SE.BLOCKDTOCLOSE + SE.BLOCKWITHDRAW + SE.EMKQTTY) ELSE 0 END) TOTAL_HLD
                                        ,(CASE WHEN SB.REFSYMBOL IS NULL THEN SUM(SE.TRADE + SE.HOLD + SE.NETTING + SE.TRANSFER+ SE.WITHDRAW) ELSE 0 END) TOTAL_AVL
                                        ,(CASE WHEN SB.REFSYMBOL IS NULL THEN 0 ELSE SUM(SE.TRADE +SE.BLOCKED + SE.BLOCKTRANFER + SE.BLOCKDTOCLOSE + SE.BLOCKWITHDRAW + SE.EMKQTTY) END) TOTAL_SEG
                                        ,(CASE WHEN SB.REFSYMBOL IS NULL THEN SUM(SE.RECEIVING) ELSE 0 END) TOTAL_REC
                                        ,NVL((
                                            CASE WHEN SB.SECTYPE IN ('003','006') OR SB.TRADEPLACE IN ('003')  THEN SB.PARVALUE
                                            ELSE SI.CLOSEPRICE END
                                        ),0) MARKET_PRICE
                                FROM SEMAST SE
                                --------------------
                                JOIN (
                                    --BANG TAM SB
                                    SELECT SB.CODEID, SB.SECTYPE, SB.SYMBOL,SB.ISINCODE,
                                            CASE
                                                 WHEN SB.SECTYPE IN ('003','006') THEN SB.BONDNAME
                                                 ELSE SB.ISSUERID
                                            END ISSUERID,
                                            SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL, SB.EXPDATE,
                                            SB.PARVALUE, SC.SHORTCD CURRENCY, (CASE WHEN SB.REFCODEID IS NULL THEN SB.TRADEPLACE ELSE SB1.TRADEPLACE END) TRADEPLACE
                                    FROM SBSECURITIES SB, SBSECURITIES SB1, SBCURRENCY SC
                                    WHERE SB.REFCODEID = SB1.CODEID(+)
                                    AND SB.SECTYPE NOT IN ('000','111','222','333','444','555','004')
                                    AND SC.CCYCD = SB.CCYCD
                                ) SB ON SB.CODEID = SE.CODEID
                                ---------------------
                                LEFT JOIN
                                    SE_INF_HIST SI
                                        ON SI.CODEID = (CASE WHEN SB.REFCODEID IS NULL THEN SB.CODEID ELSE SB.REFCODEID END)
                                ---------------------
                                WHERE SE.CUSTID IS NOT NULL

                                GROUP BY SE.CUSTID, SE.ACCTNO, SB.SECTYPE,SB.ISINCODE,SB.ISSUERID ,SB.REFSYMBOL, SB.CURRENCY,
                                (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END),
                                NVL((
                                      CASE WHEN SB.SECTYPE IN ('003','006') OR SB.TRADEPLACE IN ('003')  THEN SB.PARVALUE
                                      ELSE SI.CLOSEPRICE END
                                ),0)
                            )
                            UNPIVOT (
                                TOTAL FOR STATUS IN (
                                    TOTAL_AVL AS 'AVL',
                                    TOTAL_SEG AS 'SEG',
                                    TOTAL_HLD AS 'HLD',
                                    TOTAL_REC AS 'REC'
                                )
                            )
                            GROUP BY CUSTID,ACCTNO,SECTYPE,STATUS,SYMBOL,ISINCODE,ISSUERID,MARKET_PRICE,CURRENCY
                        ) SU
                         LEFT JOIN ( --BANG TEMP TR
                             SELECT CUSTODYCD, ACCTNO, SYMBOL, BUSDATE, FIELD, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT,
                                    (CASE WHEN FIELD IN ('BLOCKED','MORTAGE','BLOCKTRANFER','BLOCKDTOCLOSE','BLOCKWITHDRAW','EMKQTTY') AND SYMBOL NOT LIKE '%_WFT' THEN 'HLD' ELSE
                                     CASE WHEN FIELD IN ('RECEIVING') AND SYMBOL NOT LIKE '%_WFT' THEN 'REC' ELSE
                                     CASE WHEN FIELD IN ('TRADE','BLOCKED','BLOCKTRANFER','BLOCKDTOCLOSE','BLOCKWITHDRAW','EMKQTTY') AND SYMBOL LIKE '%_WFT' THEN 'SEG' ELSE
                                     CASE WHEN FIELD IN ('TRADE','HOLD','NETTING','TRANSFER','WITHDRAW') AND SYMBOL NOT LIKE '%_WFT' THEN 'AVL'
                                     END END END END) STATUS
                             FROM VW_SETRAN_GEN
                             WHERE BUSDATE > V_IDATE AND FIELD IN ('HOLD','NETTING','TRANSFER','WITHDRAW','TRADE','RECEIVING','BLOCKED','MORTAGE','BLOCKTRANFER','BLOCKDTOCLOSE','BLOCKWITHDRAW','EMKQTTY')
                             GROUP BY CUSTODYCD, ACCTNO, SYMBOL, BUSDATE, FIELD
                         ) TR ON SU.ACCTNO = TR.ACCTNO AND SU.STATUS = TR.STATUS
                         GROUP BY SU.CUSTID, SU.SECTYPE,SU.ISINCODE,SU.ISSUERID, SU.STATUS, SU.MARKET_PRICE, SU.SYMBOL, SU.CURRENCY
                    ) CK
                    WHERE CK.QUANTITY <> 0
             ) CT
             JOIN CFMAST CF ON CF.CUSTID = CT.CUSTID
                            AND CF.STATUS <> 'C'
                           -- AND CF.CUSTATCOM = 'Y' --LUU KY TAI SHINHAN
             LEFT JOIN  ISSUERS ISS ON ISS.ISSUERID = CT.ISSUERID
             LEFT JOIN (SELECT * FROM FAMEMBERS FA WHERE FA.ROLES = 'AMC')AMC ON AMC.AUTOID = CF.AMCID
             LEFT JOIN (SELECT * FROM FAMEMBERS FA WHERE FA.ROLES = 'GCB')GCB ON GCB.AUTOID = CF.GCBID
             WHERE CF.CUSTODYCD LIKE V_CUSTODYCD
                   AND NVL(AMC.SHORTNAME,'X') LIKE V_AMC
                   AND NVL(GCB.SHORTNAME,'X') LIKE V_GCB
        )
        ORDER BY FULLNAME,SYMBOL,SECURITIES_TYPE,SECURITIES_STATUS
        ;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('OD6032: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;

End;
/
