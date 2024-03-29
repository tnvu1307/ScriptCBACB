SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf601002(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*TU NGAY */
   P_REPORTNO             IN       VARCHAR2,
   T_DATE                 IN       VARCHAR2, /*DEN NGAY */
   P_CUSTODYCD            IN       VARCHAR2, /*SO TK LUU KY */
   P_SYMBOL               IN       VARCHAR2, /*MA CHUNG KHOAN */
   P_SHARESOUTTYP         IN       VARCHAR2, /*KL LUU HANH */
   P_SIGNTYPE             IN       VARCHAR2 /*NGUOI KY */
   )
IS
    -- REPORT ON THE DAY BECOME/IS NO LONGER MAJOR SHAREHOLDER, INVESTORS HOLDING 5% OR MORE OF SHARES
    -- PERSON      DATE                 COMMENTS
    -- ---------   ------               -------------------------------------------
    -- DU.PHAN    23-10-2019           CREATED
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    V_FROMDATE          DATE;
    V_TODATE            DATE;
    V_CURRDATE          DATE;
    V_CUSTODYCD         VARCHAR2(20);
    V_SYMBOL            VARCHAR2(50);
    V_BRADDRESS         VARCHAR2(200);
    V_BRADDRESS_EN      VARCHAR2(200);
    V_HEADOFFICE        VARCHAR2(200);
    V_HEADOFFICE_EN     VARCHAR2(200);
    V_EMAIL             VARCHAR2(200);
    V_PHONE             VARCHAR2(200);
    V_FAX               VARCHAR2(200);
    V_1IDCODE           VARCHAR2(200);
    V_1OFFICE           VARCHAR2(200);
    V_1REFNAME          VARCHAR2(200);
    V_2IDCODE           VARCHAR2(200);
    V_2OFFICE           VARCHAR2(200);
    V_2REFNAME          VARCHAR2(200);
    V_BUSSINESSID       VARCHAR2(200);
    V_AMCID             VARCHAR2(20);
    -- TY LE SO HUU CO DONG LON
    V_MAJORSHAREHOLDER  NUMBER(20,4);
    V_CLEARDAY          NUMBER;
BEGIN
     V_STROPTION := OPT;
     V_CURRDATE   := GETCURRDATE;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;
     --P_SYMBOL
     V_SYMBOL:= P_SYMBOL;
     IF (P_SYMBOL = 'ALL') THEN
        V_SYMBOL := '%%';
     ELSE
        V_SYMBOL :=  P_SYMBOL;
     END IF;

    V_CUSTODYCD := REPLACE(P_CUSTODYCD,'.','');
    V_FROMDATE  := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_TODATE    := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    --
    SELECT MAX(CASE WHEN  VARNAME='HEADOFFICE' THEN VARVALUE ELSE '' END)
       INTO V_HEADOFFICE
    FROM SYSVAR WHERE VARNAME IN ('HEADOFFICE');

BEGIN
    -- LAY THONG TIN
    SELECT CF.AMCID
    INTO V_AMCID
    FROM CFMAST CF
    WHERE CF.CUSTODYCD=V_CUSTODYCD
    AND CF.STATUS NOT IN ('C');
EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_AMCID:= NULL;

END;
---------------------------------------------
OPEN PV_REFCURSOR FOR
    WITH TMPINDAY AS(
                    SELECT CUSTODYCD, ACCTNO, SYMBOL,
                           SUM(CASE WHEN TXTYPE='C' THEN NAMT ELSE -NAMT END) NAMT
                    FROM VW_SETRAN_GEN
                     WHERE BUSDATE > V_FROMDATE AND FIELD IN ('TRADE','RECEIVING','MORTAGE', 'BLOCKED', 'EMKQTTY')
                        AND SYMBOL LIKE P_SYMBOL||'%'
                     GROUP BY CUSTODYCD, ACCTNO, SYMBOL
    ), TMPSB AS (
        SELECT SB.CODEID, SB.SYMBOL,
                       ISS.FULLNAME ISSFULLNAME, -- TEN TCPH
                       ISS.EN_FULLNAME EN_ISSFULLNAME, -- TEN TA TCPH
                       A1.CDCONTENT EXCHANGES,          -- TEN SO GDCK
                       A1.EN_CDCONTENT  EN_EXCHANGES,   -- TEN TA SO GDCK
                       SI.LISTINGQTTY                   -- KL NIEM YET
                FROM ISSUERS ISS, SBSECURITIES SB, ALLCODE A1,
                (
                    SELECT * FROM VW_SECURITIES_INFO_HIST WHERE HISTDATE = V_FROMDATE
                ) SI
                WHERE ISS.ISSUERID = SB.ISSUERID
                AND SB.TRADEPLACE = A1.CDVAL AND A1.CDNAME='EXCHANGES'
                AND SB.CODEID = SI.CODEID(+)
                AND SB.SYMBOL LIKE V_SYMBOL
    ),TMPLCB AS (
        SELECT FA.AUTOID LCBID, FA.FULLNAME
        FROM FAMEMBERS FA
        WHERE ROLES='LCB'
    ), TMPMST AS (
        SELECT CF.CUSTODYCD,
               CF.FULLNAME  CFFULLNAME,
               CF.CIFID,
               CASE WHEN CF.CUSTATCOM='Y' THEN V_HEADOFFICE ELSE LCB.FULLNAME END CFBANKNAME,
               SB.SYMBOL,
               SB.ISSFULLNAME,
               SB.EN_ISSFULLNAME,
               SB.EXCHANGES,
               SB.EN_EXCHANGES,
               SB.LISTINGQTTY,
               (CASE WHEN SE.CUSTATCOM = 'Y' THEN SE.TRADE + (CASE WHEN SB.SYMBOL LIKE '%_WFT' THEN 0 ELSE SE.RECEIVING END) + SE.MORTAGE + SE.BLOCKED + SE.EMKQTTY - NVL(INDAY.NAMT,0) ELSE SE.TRADE END) ENDQTTY
        FROM (
            SELECT * FROM CFMAST WHERE STATUS NOT IN ('C')
        ) CF
        LEFT JOIN CFOTHERACC CFO ON CFO.CFCUSTID = CF.CUSTID
        INNER JOIN  (
            SELECT SE.ACCTNO, SE.AFACCTNO, SE.CODEID, SE.CUSTID, SE.TRADE, SE.RECEIVING, SE.MORTAGE, SE.BLOCKED, SE.EMKQTTY, CF.CUSTATCOM
            FROM SEMAST SE, CFMAST CF
            WHERE SE.CUSTID = CF.CUSTID
            AND CF.CUSTATCOM = 'Y'
            UNION ALL
            SELECT SE.ACCTNO, SE.AFACCTNO, SE.CODEID, SE.CUSTID, SE.TRADE, SE.RECEIVING, SE.MORTAGE, SE.BLOCKED, SE.EMKQTTY, CF.CUSTATCOM
            FROM SENOCUSTATCOM SE, CFMAST CF
            WHERE SE.CUSTID = CF.CUSTID
            AND CF.CUSTATCOM = 'N'
            AND TXDATE = V_FROMDATE
        ) SE ON CF.CUSTID = SE.CUSTID
        INNER JOIN  TMPSB SB ON SE.CODEID = SB.CODEID
        LEFT JOIN TMPINDAY INDAY ON SE.ACCTNO = INDAY.ACCTNO
        LEFT JOIN TMPLCB LCB ON CF.LCBID= LCB.LCBID
        WHERE CF.AMCID = V_AMCID
              -- TY LE SO HUU
              --AND (CASE WHEN SB.LISTINGQTTY = 0 THEN 100 ELSE (SE.TRADE + SE.RECEIVING - NVL(INDAY.NAMT,0)) / SB.LISTINGQTTY END) < V_MAJORSHAREHOLDER
    )
    SELECT ROWNUM CFNO, MST.CFFULLNAME, MST.CUSTODYCD , MST.CFBANKNAME
    FROM TMPMST MST
    WHERE ENDQTTY > 0
   -- ORDER BY 1;
    UNION ALL
    SELECT TO_NUMBER(0,'9999') CFNO, NULL CFFULLNAME, NULL CUSTODYCD , NULL CFBANKNAME
    FROM DUAL;

EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('CF601002: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
