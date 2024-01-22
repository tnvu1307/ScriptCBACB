SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca6018 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   P_CACODE       IN       VARCHAR2,
   P_CUSTODYCD    IN       VARCHAR2
)
IS
    --NAM.LY 22/02/2020
    V_REPORTDATE   DATE;
    V_CACODE       VARCHAR2 (20);
    V_CUSTODYCD    VARCHAR2 (50);
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
BEGIN
    V_STROPTION := OPT;
    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:= BRID;
    END IF;
    V_REPORTDATE := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_CACODE     := P_CACODE;
    -----
    IF P_CUSTODYCD IS NULL OR P_CUSTODYCD ='ALL'
    THEN
        V_CUSTODYCD := '%';
    ELSE
        V_CUSTODYCD := P_CUSTODYCD;
    END IF;
--==============MAIN QUERY================
 OPEN PV_REFCURSOR
 FOR
        SELECT DISTINCT CA.CAMASTID, V_REPORTDATE REPORTDATE,
               CA.CODEID, CA.OPTCODEID, CA.TOCODEID, CA.REPORTDATE CAREPORTDATE, CA.ISINCODE, CA.CATYPE, CA.RIGHTOFFRATE,
               CA.EXRATE, CA.EXPRICE,TO_CHAR(CA.BEGINDATE,'DD/MM/RRRR') || ' - '||TO_CHAR(CA.DUEDATE,'DD/MM/RRRR') BEGINDATE, CA.DUEDATE, CA.INSDEADLINE, CA.DEBITDATE, CA.ACTIONDATE,
               CAS.TRADE, (CAS.BALANCE + CAS.PBALANCE) BALANCE, CAS.QTTY, A1.EN_CDCONTENT CATYPE_NAME,
               SB1.SYMBOL, SB1.ISINCODE,
               SB2.SYMBOL OPTSYMBOL, SB2.ISINCODE OPTISINCODE,
               SB3.SYMBOL TOSYMBOL, SB3.ISINCODE TOISINCODE,
               CF.CIFID, CF.FULLNAME,
               CAR.CUSTODYCD,
               NVL(CAS.QTTY,0)*NVL(CA.EXPRICE,0) AMT
        FROM CAMAST CA, CASCHD CAS, CAREGISTER CAR, ALLCODE A1, SBSECURITIES SB1, SBSECURITIES SB2, SBSECURITIES SB3, CFMAST CF, AFMAST AF, DDMAST DD
        WHERE CA.CAMASTID = CAS.CAMASTID AND CA.CODEID = CAS.CODEID AND
              CA.CAMASTID = CAR.CAMASTID AND CAR.AFACCTNO = CAS.AFACCTNO AND
              A1.CDNAME = 'CATYPE' AND A1.CDTYPE = 'CA' AND A1.CDVAL = CA.CATYPE AND
              CA.CODEID = SB1.CODEID AND
              CA.OPTCODEID = SB2.CODEID AND
              CA.TOCODEID = SB3.CODEID AND
              CF.CUSTODYCD = CAR.CUSTODYCD AND
              AF.ACCTNO = DD.AFACCTNO AND
              DD.STATUS <> 'C' AND DD.ISDEFAULT = 'Y' AND
              DD.BALANCE < CAS.PAAMT AND
              DD.CUSTODYCD = CF.CUSTODYCD AND
              CA.CAMASTID LIKE V_CACODE AND
              CAR.CUSTODYCD LIKE V_CUSTODYCD AND
              FN_GET_DATE_DIFF(V_REPORTDATE,CA.DEBITDATE,'B') = 2;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('CA6018: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
