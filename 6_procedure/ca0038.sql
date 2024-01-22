SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE CA0038 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   CACODE           in        varchar2,
   ISCOREBANK     IN       VARCHAR2,
   CASHPLACE      IN       VARCHAR2,
   TLLID     in        varchar2
  )
IS
--

    CUR             PKG_REPORT.REF_CURSOR;
    V_STROPTION    VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (40);
    V_INBRID       VARCHAR2 (4);
    V_STRACCTNO    VARCHAR2 (20);
    V_CACODE       VARCHAR2 (20);
    V_TLLID  VARCHAR2 (4);
    V_ISCOREBANK        VARCHAR2(10);
    V_CASHPLACE         VARCHAR2(100);

BEGIN

   V_STROPTION := upper(OPT);
   V_TLLID:= TLLID;
   V_INBRID := BRID;
   IF (V_STROPTION = 'A') THEN
      V_STRBRID := '%';
   ELSE if(V_STROPTION = 'B') then
          select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
   END IF;

   IF(CACODE <> 'ALL')   THEN  V_CACODE  := CACODE;
   ELSE   V_CACODE  := '%';
   END IF;

   IF (ISCOREBANK <> 'ALL' OR ISCOREBANK <> '')
   THEN
            V_ISCOREBANK :=  ISCOREBANK;
   ELSE
      V_ISCOREBANK := '%';
   END IF;

   IF (CASHPLACE <> 'ALL' OR CASHPLACE <> '')
   THEN
      V_CASHPLACE :=  CASHPLACE;
   ELSE
      V_CASHPLACE := '%';
   END IF;



OPEN PV_REFCURSOR
   FOR

    SELECT SUM(TRADE) TRADE, SUM(CAS.TRADE - CAS.BALANCE) EXQTTY, SUM(CAS.BALANCE) BALANCE , SUM(CAS.AMT) AMT , CUSTODYCD, CF.FULLNAME, CF.IDCODE, CF.IDDATE, CF.address IDPLACE ,
        CF.COUNTRY,  CA.CODEID , SB.SYMBOL, CA.PARVALUE, CA.EXRATE, BEGINDATE,DUEDATE, REPORTDATE,ACTIONDATE, ISS.FULLNAME ISSFULLNAME, CA.INTERESTRATE, CA.TOCODEID, CA.CIROUNDTYPE, TL.BRID
    FROM CAMAST CA, CASCHD CAS, CFMAST CF, AFMAST AF, BRGRP BR, SBSECURITIES SB, ISSUERS ISS, TLPROFILES TL, AFTYPE AFT
    WHERE CF.CUSTID=AF.CUSTID AND CAS.AFACCTNO = AF.ACCTNO
        AND   AF.ACTYPE     =  AFT.ACTYPE
        AND CA.CAMASTID=CAS.CAMASTID AND CA.CATYPE='023'
        AND BR.BRID = SUBSTR(AF.ACCTNO,1,4) AND SB.CODEID=CA.CODEID
        AND ISS.SHORTNAME = SB.SYMBOL
       -- AND  (SUBSTR(AF.ACCTNO,1,4) LIKE V_STRBRID OR INSTR(V_STRBRID,SUBSTR(AF.ACCTNO,1,4)) <> 0)
        AND   AFT.COREBANK  LIKE V_ISCOREBANK
        AND   AF.BANKNAME   LIKE V_CASHPLACE
        AND CA.camastid= V_CACODE
        and cas.deltd <> 'Y'
        AND TL.TLID= V_TLLID
    GROUP BY CUSTODYCD,CF.FULLNAME, CF.IDCODE, CF.IDDATE, CF.address ,
        CF.COUNTRY,  CA.CODEID , SB.SYMBOL, CA.PARVALUE, CA.EXRATE,BEGINDATE, DUEDATE, REPORTDATE,ACTIONDATE, ISS.FULLNAME, CA.INTERESTRATE, CA.TOCODEID, CA.CIROUNDTYPE, TL.BRID
    ORDER BY CUSTODYCD
    ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
