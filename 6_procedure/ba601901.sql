SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE BA601901(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   I_DATE                 IN       VARCHAR2,
   PV_ISSUECODE           IN       VARCHAR2,
   PV_CUSTODYCD           IN       VARCHAR2,
   PV_SYMBOL              IN       VARCHAR2,
   PV_TXNUM               IN       VARCHAR2 /*SO CHUNG TU*/
   )
IS
-- PERSON    DATE          COMMENTS
-- NAM.LY    12-DEC-2019   MODIFIED
    V_STROPTION     VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID       VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
    V_IDATE         DATE;
    V_currdate      DATE;
    V_ISSUER        VARCHAR(50);
    V_ISSUECODE    VARCHAR(20);
    V_CUSTODYCD     VARCHAR(20);
    V_SYMBOL        VARCHAR(20);
    v_TXNUM         VARCHAR2(10);
BEGIN
     V_STROPTION := OPT;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;
    -------------------------
    V_currdate := GETCURRDATE;
    V_IDATE      :=  TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);    
    V_ISSUECODE:=PV_ISSUECODE;
    V_CUSTODYCD:=REPLACE(PV_CUSTODYCD,'.','');
    v_TXNUM      :=  PV_TXNUM;    
    -------------------------
    IF(PV_SYMBOL='ALL') THEN
        V_SYMBOL:='%';
    ELSE
        V_SYMBOL:=PV_SYMBOL;
    END IF;
    -------------------------  
OPEN PV_REFCURSOR FOR
            SELECT  --ISS.FULLNAME FULLNAMEBOND, --TEN TCPH
                    --RS.CONTRACTNO, --SO HOP DONG
                    --RS.CONTRACTDATE, --NGAY HOP DONG
                    --RS.SYMBOL, --MA TRAI PHIEU
                    RS.THIRDPARTNER,
                    TO_CHAR(RS.ISSUEDATE,'DD/MM/RRRR') ISSUEDATE, -- NGAY PHAT HANH
                    --RS.EXPDATE, -- NGAY DAO HAN
                    --TO_CHAR(UTILS.SO_THANH_CHU(NVL(RS.VALUEOFISSUE,0))) AS VALUEOFISSUE, --GIA TRI PHAT HANH
                    --RS.PARVALUE, -- MENH GIA
                    --RS.INTCOUPON, -- LAI SUAT
                    CF.FULLNAME, --TEN KH
                    (CASE WHEN CF.COUNTRY ='234' THEN CF.IDCODE ELSE CF.TRADINGCODE END) IDCODE,
                    (CASE WHEN CF.COUNTRY ='234' THEN CF.IDDATE ELSE CF.TRADINGCODEDT END) IDDATE,
                    CF.IDPLACE,--NOI CAP GIAY TO
                    CF.ADDRESS,--DIA CHI KH
                    RS.TRADE,
                    RS.SYMBOL BONDSYMBOL--MA TRAI PHIEU NAM GIU
            FROM
                (
                 SELECT BSE.AFACCTNO,BSE.BONDSYMBOL, SB.ISSUERID, SB.ISSUEDATE, SB.EXPDATE, SB.VALUEOFISSUE
                      , SB.PARVALUE, SB.INTCOUPON, SB.CONTRACTNO, SB.CONTRACTDATE, SB.THIRDPARTNER
                      , (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END) SYMBOL
                      , SUM(BSE.TRADE - NVL(TR.NAMT,0)) TRADE
                 FROM (
                        SELECT SB.CODEID, SB.SECTYPE, SB.SYMBOL, SB1.CODEID REFCODEID, SB1.SYMBOL REFSYMBOL
                              , SB.ISSUERID, SB.ISSUEDATE, SB.EXPDATE, SB.VALUEOFISSUE, SB.PARVALUE
                              , SB.INTCOUPON, SB.CONTRACTNO, SB.CONTRACTDATE, SB.THIRDPARTNER
                        FROM SBSECURITIES SB, SBSECURITIES SB1
                        WHERE SB.REFCODEID = SB1.CODEID(+) AND
                              SB.SECTYPE IN ('003','006') AND
                              SB.SECTYPE <> '004' AND
                              SB.CONTRACTNO IS NOT NULL
                      ) SB,
                      (
                        SELECT ACCTNO, TXDATE, SUM(CASE WHEN  TXCD='1902' THEN NAMT ELSE -NAMT END) NAMT
                        FROM VW_BONDTRAN
                        WHERE BKDATE > V_IDATE
                        GROUP BY ACCTNO, TXDATE
                      ) TR,
                      BONDSEMAST BSE
                  WHERE BSE.BONDCODE = SB.CODEID 
                        AND BSE.CUSTODYCD =V_CUSTODYCD
                        AND BSE.ACCTNO = TR.ACCTNO (+)
                  GROUP BY BSE.AFACCTNO, BSE.BONDSYMBOL, SB.ISSUERID, SB.ISSUEDATE, SB.EXPDATE, SB.VALUEOFISSUE
                         , SB.PARVALUE, SB.INTCOUPON, SB.CONTRACTNO, SB.CONTRACTDATE, SB.THIRDPARTNER
                         , (CASE WHEN SB.REFSYMBOL IS NULL THEN SB.SYMBOL ELSE SB.REFSYMBOL END)
                 ) RS,
                 ISSUERS ISS, CFMAST CF, AFMAST AF, ISSUES IE, BONDISSUE BO
            WHERE RS.ISSUERID = ISS.ISSUERID AND
                  CF.CUSTID =AF.CUSTID AND
                  AF.ACCTNO = RS.AFACCTNO AND
                  RS.TRADE <> 0 AND
                  RS.BONDSYMBOL = BO.BONDSYMBOL AND
                  BO.ISSUESID = IE.AUTOID AND  
                  RS.SYMBOL LIKE V_SYMBOL AND
                  IE.ISSUECODE = V_ISSUECODE 

;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('BA601901: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
