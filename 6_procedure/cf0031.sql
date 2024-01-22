SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf0031 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   I_BRIDGD       IN       VARCHAR2
 )
IS
--
-- PURPOSE: DSKH DA TAT TOAN TK (BC GUI HOSE)
-- MODIFICATION HISTORY
-- PERSON      DATE      COMMENTS
-- QUOCTA   24-12-2011   CREATED - NOEL
-- ---------   ------  -------------------------------------------

   V_STROPTION         VARCHAR2  (5);
   V_STRBRID           VARCHAR2  (40);

   V_F_DATE            DATE;
   V_T_DATE            DATE;

   V_I_BRIDGD          VARCHAR2(100);
   V_BRNAME            NVARCHAR2(400);
    V_BRID             VARCHAR2(4);
BEGIN
   V_STROPTION := OPT;
      V_BRID := BRID;


    IF  V_STROPTION = 'A' then
        V_STRBRID := '%';
        ELSIF V_STROPTION = 'B' THEN
            SELECT BR.MAPID INTO V_STRBRID FROM BRGRP BR WHERE BR.BRID = V_BRID;
        ELSE V_STROPTION := V_BRID;
    END IF;

   -- GET REPORT'S PARAMETERS
   V_F_DATE        := TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
   V_T_DATE        := TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);

   IF (I_BRIDGD <> 'ALL' OR I_BRIDGD <> '')
   THEN
      V_I_BRIDGD :=  I_BRIDGD;
   ELSE
      V_I_BRIDGD := '%%';
   END IF;

   IF (I_BRIDGD <> 'ALL' OR I_BRIDGD <> '')
   THEN
      BEGIN
            SELECT BRNAME INTO V_BRNAME FROM BRGRP WHERE BRID LIKE I_BRIDGD;
      END;
   ELSE
      V_BRNAME   :=  ' To?c?ng ty ';
   END IF;

   -- GET REPORT'S DATA

OPEN PV_REFCURSOR
FOR
    /*SELECT CF.FULLNAME, '005' TVCODE, CF.CUSTODYCD, CF.IDCODE, CF.ADDRESS, CF.IDDATE, CF.IDPLACE,
           (CASE WHEN substr(cf.custodycd,4,1) = 'F' THEN 'NN' ELSE 'TN' END) || '-' ||
    (CASE WHEN CF.CUSTTYPE = 'I' THEN 'CN' WHEN CF.CUSTTYPE = 'B' THEN 'TC' END) CUSTTYPE_NAME,
           CF.OPNDATE, AL.CDCONTENT COUNTRY_NAME, CF.CFCLSDATE, V_BRNAME BRNAME
    FROM  CFMAST CF, ALLCODE AL
    WHERE CF.COUNTRY = AL.CDVAL
    AND   AL.CDNAME  = 'COUNTRY'
    AND   AL.CDTYPE  = 'CF'
    AND   CF.CFCLSDATE >= V_F_DATE AND CF.CFCLSDATE <  V_T_DATE
    AND   (substr(custid,1,4) LIKE V_STRBRID OR INSTR(V_STRBRID,substr(custid,1,4))<> 0)
    AND   substr(custid,1,4)      LIKE V_I_BRIDGD
    AND   CF.STATUS    = 'C'

;*/
    SELECT CF.FULLNAME, '005' TVCODE, CF.CUSTODYCD, CF.IDCODE, CF.ADDRESS, CF.IDDATE, CF.IDPLACE,
           (CASE WHEN nvl(cf.country,'234') <> '234' THEN 'NN' ELSE 'TN' END) || '-' ||
    (CASE WHEN CF.CUSTTYPE = 'I' THEN 'CN' WHEN CF.CUSTTYPE = 'B' THEN 'TC' END) CUSTTYPE_NAME,
           CF.OPNDATE, AL.CDCONTENT COUNTRY_NAME, CF.CFCLSDATE, V_BRNAME BRNAME
    FROM  CFMAST CF, ALLCODE AL, ((SELECT CF.CUSTID FROM vw_tllog_all, cfmast cf
                                    WHERE tltxcd = '0059' AND busdate >= V_F_DATE and busdate <= V_T_DATE AND deltd <> 'Y'
                                    AND cf.custid = vw_tllog_all.msgacct
                                    AND cf.custatcom = 'Y' AND CF.custodycd IS NOT NULL
                                    )) tl
    WHERE CF.COUNTRY = AL.CDVAL
    AND   CF.CUSTID  = TL.CUSTID
    AND   AL.CDNAME  = 'COUNTRY'
    AND   AL.CDTYPE  = 'CF'
    AND   (substr(CF.custid,1,4) LIKE V_STRBRID OR INSTR(V_STRBRID,substr(CF.custid,1,4))<> 0)
    AND   substr(CF.custid,1,4)      LIKE V_I_BRIDGD
;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;



-- END OF DDL SCRIPT FOR PROCEDURE HOST.CF0031
 
 
 
 
/
