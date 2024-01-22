SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca0019 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   CACODE         IN       VARCHAR2,
   I_BRIDGD       IN       VARCHAR2,
   ISCOREBANK     IN       VARCHAR2,
   CASHPLACE      IN       VARCHAR2
 )
IS
--
-- PURPOSE: BAO CAO DANH SACH NGUOI SO HUU CHUNG KHOAN LUU KY
-- MODIFICATION HISTORY
-- PERSON      DATE      COMMENTS
-- QUOCTA   15-12-2011   CREATED
-- ---------   ------  -------------------------------------------

   V_STROPTION         VARCHAR2  (5);
   V_STRBRID           VARCHAR2  (4);
   V_CACODE            VARCHAR2(100);
   V_I_BRIDGD          VARCHAR2(100);
   V_ISCOREBANK        VARCHAR2(10);
   V_CASHPLACE         VARCHAR2(100);

   V_BRNAME            NVARCHAR2(500);
   V_COREBANK_NAME     NVARCHAR2(100);
   V_CASHPLACE_NAME    NVARCHAR2(500);

BEGIN
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;

   -- GET REPORT'S PARAMETERS
   IF (CACODE <> 'ALL' OR CACODE <> '')
   THEN
      V_CACODE := REPLACE(CACODE,'.','');
   ELSE
      V_CACODE := '%';
   END IF;

   IF (I_BRIDGD <> 'ALL' OR I_BRIDGD <> '')
   THEN
      V_I_BRIDGD :=  I_BRIDGD;
   ELSE
      V_I_BRIDGD := '%';
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

   IF (I_BRIDGD <> 'ALL' OR I_BRIDGD <> '')
   THEN
      BEGIN
            SELECT BRNAME INTO V_BRNAME FROM BRGRP WHERE BRID LIKE I_BRIDGD;
      END;
   ELSE
      V_BRNAME   :=  'Toàn công ty';
   END IF;

   IF (ISCOREBANK <> 'ALL' OR ISCOREBANK <> '')
   THEN
        if (ISCOREBANK = 'Y') then
            V_COREBANK_NAME := 'Corebank';
        else
            V_COREBANK_NAME := 'Tại cty CK';
        end if;
   ELSE
      V_COREBANK_NAME   :=  'Toàn công ty';
   END IF;

   IF (CASHPLACE <> 'ALL' OR CASHPLACE <> '')
   THEN
      BEGIN
            SELECT CDCONTENT INTO V_CASHPLACE_NAME FROM ALLCODE WHERE CDTYPE = 'CF' AND CDNAME = 'BANKNAME' AND CDVAL LIKE CASHPLACE;
      END;

   ELSE
      V_CASHPLACE_NAME   :=  'All';
   END IF;

   -- GET REPORT'S DATA

OPEN PV_REFCURSOR
FOR
     SELECT ISS.FULLNAME ISS_NAME, SB.SYMBOL, SB.PARVALUE, MST.REPORTDATE,
             NVL(MST.DEVIDENTSHARES, 0) PCENT, NVL(MST.EXPRICE, 0) EXPRICE,
            SUBSTR(CF.CUSTODYCD, 4, 1) GR_I,
            (case when CF.CUSTTYPE = 'I' then '1.' else '2.' end) || CF.CUSTTYPE AFTYPE,
            CF.CUSTID, CF.FULLNAME,
            --CF.IDCODE,
            (case when cf.country = '234' then cf.idcode else cf.tradingcode end) IDCODE,
            (case when cf.country = '234' then cf.IDDATE else cf.tradingcodedt end) IDDATE, CF.ADDRESS, AL.CDCONTENT COUNTRY_NAME,
            CF.CUSTODYCD, AF.ACCTNO AFACCTNO, (CA.BALANCE + CA.PBALANCE) BALANCE, (CA.QTTY + CA.PQTTY) QTTY,
            (CASE WHEN NVL(MST.EXPRICE, 0) = 0 THEN 0 ELSE ROUND(CA.AMT / MST.EXPRICE, 3) END) AMT_OD,
            NVL(CA.AMT, 0) AMT, s1.symbol tosymbol,
            V_BRNAME BR_NAME, V_COREBANK_NAME COREBANK_NAME,
            V_CASHPLACE_NAME CASHPLACE_NAME
    FROM VW_CASCHD_ALL CA, AFMAST AF, CFMAST CF, ALLCODE AL, SBSECURITIES SB, ISSUERS ISS, sBsecurities s1, AFTYPE AFT,
         (SELECT * FROM CAMAST UNION ALL SELECT * FROM CAMASTHIST) MST
    WHERE CA.AFACCTNO    = AF.ACCTNO
    AND   AF.CUSTID      = CF.CUSTID
    AND   CF.COUNTRY     = AL.CDVAL
    AND   AL.CDNAME      = 'COUNTRY'
    AND   CA.CODEID      = SB.CODEID
    AND   SB.ISSUERID    = ISS.ISSUERID
    and   s1.codeid = MST.tocodeid
    AND   CA.DELTD       <>'Y'
    AND   (CA.BALANCE + CA.PBALANCE) > 0
    AND   CA.CAMASTID   =  MST.CAMASTID
    AND   MST.CATYPE    IN  ('020')
    ---AND   CF.BRID       LIKE V_I_BRIDGD
    ---AND   CA.CAMASTID   LIKE V_CACODE
    AND   AF.ACTYPE     =  AFT.ACTYPE
    ---AND   AFT.COREBANK  LIKE V_ISCOREBANK
    ---AND   AF.BANKNAME   LIKE V_CASHPLACE
;

-------select * from cfmast ;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
