SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE BA6002(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   RPT_DATE                 IN       VARCHAR2, /*Report date*/
   PV_SYMBOL              IN       VARCHAR2,
   PV_CUSTODYCD           IN       VARCHAR2,
   I_DATE                 IN       VARCHAR2
   )
IS

    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
--
    v_RPTDate          date;
    v_IDate            date;
    v_CustodyCD         varchar2(20);
    v_Symbol            varchar2(50);
BEGIN
     V_STROPTION := OPT;
     if v_stroption = 'A' then
        v_strbrid := '%';
     elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
     else
        v_strbrid:=brid;
     end if;

    v_RPTDate  := TO_DATE(RPT_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_IDate    := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);

    select max(sbdate) into v_IDate from sbcldr where sbdate <= TRUNC (LAST_DAY (add_months(v_IDate,-1))) and holiday='N';
---    PLOG.ERROR('RPT_DATE'||RPT_DATE||' PV_SYMBOL'||PV_SYMBOL||' PV_CUSTODYCD'|| PV_CUSTODYCD||' I_DATE'||I_DATE);
OPEN PV_REFCURSOR FOR
    WITH SE_INF_HIST AS (
        SELECT SEH1.CODEID, SEH1.CLOSEPRICE, SEH1.AVGPRICE
        FROM (
            SELECT CODEID, HISTDATE, CLOSEPRICE, AVGPRICE FROM VW_SECURITIES_INFO_HIST WHERE HISTDATE <= v_IDate AND BASICPRICE > 0
        ) SEH1,(
            SELECT CODEID, MAX(HISTDATE) HISTDATE FROM VW_SECURITIES_INFO_HIST WHERE HISTDATE <= v_IDate AND BASICPRICE > 0 GROUP BY CODEID
        ) SEH2
        WHERE SEH1.CODEID = SEH2.CODEID
        AND SEH1.HISTDATE = SEH2.HISTDATE
    )
    --==========================================MAIN SELECT QUERY=======================================================================
    SELECT FULLNAME,RPTDATE,FDATE,IDCODE,IDDATE,UTILS.so_thanh_chu(SUM(TRADE)) TRADE,FULLNAMEBOND,CONTRACTNO,
    CASE WHEN CONTRACTDATE IS NULL THEN ' ngày  tháng  năm     '
    else ' ngày '||TO_CHAR(CONTRACTDATE,'DD')||' tháng '||TO_CHAR(CONTRACTDATE,'MM')||' năm '||TO_CHAR(CONTRACTDATE,'RRRR')
    end CONTRACTDATE, CASE WHEN CONTRACTDATE2 IS NULL THEN ' ngày  tháng  năm     '
    else ' ngày '||TO_CHAR(CONTRACTDATE2,'DD')||' tháng '||TO_CHAR(CONTRACTDATE2,'MM')||' năm '||TO_CHAR(CONTRACTDATE2,'RRRR')
    end  CONTRACTDATE2,ISSUEDATE,SECTYPE
    FROM (
    --Chung quyen
    SELECT CF.FULLNAME
    ,v_RPTDate RPTDATE
    ,v_IDate FDATE
    ,(CASE WHEN CF.COUNTRY ='234' THEN CF.IDCODE ELSE CF.TRADINGCODE END) IDCODE
    ,(CASE WHEN CF.COUNTRY ='234' THEN CF.IDDATE ELSE CF.TRADINGCODEDT END) IDDATE
    ,SE.QUANTITY TRADE
    ,ISS.FULLNAME FULLNAMEBOND
    ,NVL(MST2.CONTRACTNO,' ') CONTRACTNO
    ,MST2.CONTRACTDATE
    ,MST.CONTRACTDATE CONTRACTDATE2
    ,SB.ISSUEDATE
    ,(CASE WHEN SB.SECTYPE='006' THEN 'Trái Phiếu' else 'Chứng quyền' END) SECTYPE

    FROM (
                SELECT CK.CUSTID,CK.SYMBOL,SUM(QUANTITY) QUANTITY
                FROM (
                    --BANG TEMP CHUNG KHOAN
                    SELECT SU.CUSTID
                        , SU.SYMBOL
                        , SU.STATUS SECURITIES_STATUS
                        , SUM(SU.TOTAL - NVL(TR.NAMT,0)) QUANTITY
                     FROM (
                        --BANG TEMP TINH SO DU CHUNG KHOAN
                         SELECT CUSTID,ACCTNO,SECTYPE,STATUS,SYMBOL,SUM(TOTAL)TOTAL
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
                            (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END)
                            )
                        UNPIVOT (
                            TOTAL FOR STATUS IN (
                                TOTAL_AVL AS 'AVL',
                                TOTAL_SEG AS 'SEG',
                                TOTAL_HLD AS 'HLD',
                                TOTAL_BLO AS 'BLO'
                            )
                        )
                        GROUP BY CUSTID,ACCTNO,SECTYPE,STATUS,SYMBOL
                  ) SU
                 LEFT JOIN ( --BANG TEMP TR
                     SELECT CUSTODYCD, ACCTNO, SYMBOL, BUSDATE, FIELD, SUM(CASE WHEN  TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT,
                            (CASE WHEN FIELD IN ('NETTING','WITHDRAW','BLOCKWITHDRAW') AND SYMBOL NOT LIKE '%_WFT' THEN 'HLD' ELSE
                             CASE WHEN FIELD IN ('BLOCKED','MORTAGE') AND SYMBOL NOT LIKE '%_WFT' THEN 'BLO' ELSE
                             CASE WHEN FIELD IN ('TRADE','BLOCKED') AND SYMBOL LIKE '%_WFT' THEN 'SEG' ELSE
                             CASE WHEN FIELD IN ('TRADE','HOLD') AND SYMBOL NOT LIKE '%_WFT' THEN 'AVL'
                             END END END END) STATUS
                     FROM VW_SETRAN_GEN
                     WHERE BUSDATE > v_IDate AND FIELD IN ('HOLD','NETTING','BLOCKED','TRADE','WITHDRAW','BLOCKWITHDRAW','MORTAGE')
                     GROUP BY CUSTODYCD, ACCTNO, SYMBOL, BUSDATE, FIELD
                   ) TR ON SU.ACCTNO = TR.ACCTNO AND SU.STATUS = TR.STATUS
                   GROUP BY SU.CUSTID, SU.SECTYPE, SU.STATUS,SU.SYMBOL
               ) CK
               group by CK.CUSTID,CK.SYMBOL) SE,CFMAST CF,SBSECURITIES SB,ISSUERS ISS,
               (SELECT ISS.ISSUECODE,ISS.ISSUERID,BI.BONDCODE,MST.CONTRACTNO,MST.CONTRACTDATE FROM ISSUER_CONTRACTNO MST, ISSUES ISS,BONDISSUE BI
                WHERE ISS.AUTOID = MST.ISSUESID AND BI.ISSUESID = ISS.AUTOID
                AND MST.CONTRACTTYPE='001') MST,(SELECT ISS.ISSUECODE,ISS.ISSUERID,BI.BONDCODE,MST.CONTRACTNO,MST.CONTRACTDATE FROM ISSUER_CONTRACTNO MST, ISSUES ISS,BONDISSUE BI
                WHERE ISS.AUTOID = MST.ISSUESID AND BI.ISSUESID = ISS.AUTOID
                AND MST.CONTRACTTYPE='003') MST2
               WHERE SB.ISSUERID = ISS.ISSUERID AND SE.CUSTID = CF.CUSTID
               AND SE.SYMBOL= SB.SYMBOL
                AND ISS.ISSUERID=MST.ISSUERID (+)
               AND SB.CODEID=MST.BONDCODE (+)
               AND ISS.ISSUERID=MST2.ISSUERID (+)
               AND SB.CODEID=MST2.BONDCODE (+)
               AND CF.CUSTODYCD=PV_CUSTODYCD
               AND SB.SYMBOL = PV_SYMBOL

               union all
    --Trai phieu
    SELECT DISTINCT CF.FULLNAME
    ,v_RPTDate RPTDATE
    ,v_IDate FDATE
    ,(CASE WHEN CF.COUNTRY ='234' THEN CF.IDCODE ELSE CF.TRADINGCODE END) IDCODE
    ,(CASE WHEN CF.COUNTRY ='234' THEN CF.IDDATE ELSE CF.TRADINGCODEDT END) IDDATE
    ,SE.TRADE
    ,ISS.FULLNAME FULLNAMEBOND
    ,NVL(MST2.CONTRACTNO,' ') CONTRACTNO
    ,MST2.CONTRACTDATE
    ,MST.CONTRACTDATE CONTRACTDATE2
    ,SB.ISSUEDATE
    ,(CASE WHEN SB.SECTYPE='006' THEN 'Trái Phiếu' else 'Chứng quyền' END) SECTYPE
    FROM BONDSEMAST SE,AFMAST AF,CFMAST CF,SBSECURITIES SB,ISSUERS ISS,ISSUES ISS1,BONDISSUE BI,
               (SELECT ISS.ISSUECODE,ISS.ISSUERID,BI.BONDCODE,MST.CONTRACTNO,MST.CONTRACTDATE FROM ISSUER_CONTRACTNO MST, ISSUES ISS,BONDISSUE BI
                WHERE ISS.AUTOID = MST.ISSUESID AND BI.ISSUESID = ISS.AUTOID
                AND MST.CONTRACTTYPE='001') MST,(SELECT ISS.ISSUECODE,ISS.ISSUERID,BI.BONDCODE,MST.CONTRACTNO,MST.CONTRACTDATE FROM ISSUER_CONTRACTNO MST, ISSUES ISS,BONDISSUE BI
                WHERE ISS.AUTOID = MST.ISSUESID AND BI.ISSUESID = ISS.AUTOID
                AND MST.CONTRACTTYPE='003') MST2
               WHERE SB.ISSUERID = ISS.ISSUERID AND SE.AFACCTNO = CF.CUSTID
               AND SE.BONDSYMBOL= SB.SYMBOL
               AND ISS.ISSUERID=MST.ISSUERID
                AND ISS.ISSUERID=MST.ISSUERID (+)
               AND SB.CODEID=MST.BONDCODE (+)
               AND ISS.ISSUERID=MST2.ISSUERID (+)
               AND SB.CODEID=MST2.BONDCODE (+)
               AND CF.CUSTODYCD=PV_CUSTODYCD
               AND SB.SYMBOL = PV_SYMBOL
               ) GROUP BY  FULLNAME,RPTDATE,FDATE,IDCODE,IDDATE,FULLNAMEBOND,CONTRACTNO,
    CONTRACTDATE,CONTRACTDATE2,ISSUEDATE,SECTYPE
               ;
EXCEPTION
WHEN OTHERS THEN
    PLOG.ERROR ('BA6002: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RETURN;

END;
/
