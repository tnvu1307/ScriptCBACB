SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca0032 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   PLSENT         IN       VARCHAR2
 )
IS

   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID          VARCHAR2 (4);        -- USED WHEN V_NUMOPTION > 0
-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE

BEGIN
-- INSERT INTO TEMP_BUG(TEXT) VALUES('CF0001');COMMIT;
   V_STROPTION := OPT;

   IF (V_STROPTION <> 'A') AND (BRID <> 'ALL')
   THEN
      V_STRBRID := BRID;
   ELSE
      V_STRBRID := '%%';
   END IF;


OPEN PV_REFCURSOR FOR
SELECT 
    SYMBOL, OPTSYMBOL, ISINCODE, CF1.CUSTODYCD, ISSNAME, CF1.FULLNAME, CF1.ADDRESS,
        (CASE WHEN CF1.COUNTRY = '234' THEN CF1.IDCODE ELSE CF1.TRADINGCODE END) LICENSE,
        TO_CHAR((CASE WHEN CF1.COUNTRY = '234' THEN CF1.IDDATE ELSE CF1.TRADINGCODEDT END),'DD/MM/RRRR') IDDATE,
        CF1.IDPLACE, CF1.quoc_gia COUNTRY, A.TVLKNAME,
        NVL(CF2.CUSTODYCD,A.CUSTODYCD2) CUSTODYCD2, A.TOMEMCUS, 
        NVL(CF2.FULLNAME,A.FULLNAME2)FULLNAME2,NVL(CF2.ADDRESS,A.ADDRESS2) ADDRESS2,
        (CASE WHEN NVL(CF2.COUNTRY,'') = '234' THEN NVL(CF2.IDCODE,'') ELSE NVL(CF2.TRADINGCODE,'') END) LICENSE2,
        CASE WHEN CF2.CUSTODYCD IS NOT NULL THEN 
            TO_CHAR((CASE WHEN NVL(CF2.COUNTRY,'') = '234' THEN NVL(CF2.IDDATE,'') ELSE NVL(CF2.TRADINGCODEDT,'') END),'DD/MM/RRRR') 
        ELSE A.IDDATE2
        END IDDATE2,
        NVL(CF2.IDPLACE,A.IDPLACE2) IDPLACE2, NVL(CF2.quoc_gia,A.COUNTRY2) COUNTRY2, A.TVLKNAME2,
        A.DES, A.AMT, A.MANT, A.RAMT,
        A.NUOC_NGOAI, A.TU_DOANH, A.TRONG_NUOC, A.TOSYMBOL, A.TOISSNAME, A.TXDATE,A.SENDTO
FROM
(
    SELECT SB.SYMBOL, CA.OPTSYMBOL, CA.ISINCODE, TR.CUSTODYCD, TR.ISSNAME, CF.FULLNAME, CF.ADDRESS,
        (CASE WHEN CF.COUNTRY = '234' THEN CF.IDCODE ELSE CF.TRADINGCODE END) LICENSE,
        TO_CHAR((CASE WHEN CF.COUNTRY = '234' THEN CF.IDDATE ELSE CF.TRADINGCODEDT END),'DD/MM/RRRR') IDDATE,
        CF.IDPLACE, TR.COUNTRY, NVL(DEP.FULLNAME,'') TVLKNAME,
        TR.CUSTODYCD2, TR.TOMEMCUS, TR.FULLNAME2 FULLNAME2, TR.ADDRESS2 ADDRESS2,
        TR.LICENSE2 LICENSE2,
        TR.IDDATE2 IDDATE2,
        TR.IDPLACE2 IDPLACE2, TR.COUNTRY2, NVL(DEP2.FULLNAME,'') TVLKNAME2,
        TR.DES, TR.AMT, TR.MANT, TR.RAMT,
        0 NUOC_NGOAI,  0  TU_DOANH,  0 TRONG_NUOC, TOSYMBOL, TOISSNAME, TR.TXDATE, PLSENT SENDTO
    FROM (
        SELECT TL.TXNUM,TL.TXDATE,
            MAX(DECODE(FLD.FLDCD,'06',CVALUE,NULL)) CAMASTID, --M?KQ
            MAX(DECODE(FLD.FLDCD,'35',CVALUE,NULL)) SYMBOL,-- B?CHUYEN
            MAX(DECODE(FLD.FLDCD,'36',CVALUE,NULL)) CUSTODYCD,
            MAX(DECODE(FLD.FLDCD,'38',CVALUE,NULL)) ISSNAME,
            MAX(DECODE(FLD.FLDCD,'80',CVALUE,NULL)) COUNTRY,
            MAX(DECODE(FLD.FLDCD,'21',NVALUE,NULL)) AMT,
            MAX(DECODE(FLD.FLDCD,'22',NVALUE,NULL)) MANT,
            MAX(DECODE(FLD.FLDCD,'23',NVALUE,NULL)) RAMT,
            MAX(DECODE(FLD.FLDCD,'07',CVALUE,NULL)) CUSTODYCD2,
            MAX(DECODE(FLD.FLDCD,'08',CVALUE,NULL)) TOMEMCUS,
            MAX(DECODE(FLD.FLDCD,'95',CVALUE,NULL)) FULLNAME2,
            MAX(DECODE(FLD.FLDCD,'96',CVALUE,NULL)) ADDRESS2,
            MAX(DECODE(FLD.FLDCD,'97',CVALUE,NULL)) LICENSE2,
            MAX(DECODE(FLD.FLDCD,'98',CVALUE,NULL)) IDDATE2,
            MAX(DECODE(FLD.FLDCD,'99',CVALUE,NULL)) IDPLACE2,
            MAX(DECODE(FLD.FLDCD,'81',CVALUE,NULL)) COUNTRY2,
            MAX(DECODE(FLD.FLDCD,'60',CVALUE,NULL)) TOSYMBOL,
            MAX(DECODE(FLD.FLDCD,'61',CVALUE,NULL)) TOISSNAME,
            MAX(DECODE(FLD.FLDCD,'30',CVALUE,NULL)) DES--DIENGIAI
        FROM VW_TLLOG_ALL TL, VW_TLLOGFLD_ALL FLD
        WHERE TL.TXNUM=FLD.TXNUM
        AND TL.TXDATE=FLD.TXDATE
        AND TL.TXDATE >=TO_DATE(F_DATE,'DD/MM/YYYY')
        AND TL.TXDATE <=TO_DATE(T_DATE,'DD,MM,YYYY')
        AND TL.TLTXCD IN ('3383')
        AND FLD.FLDCD IN ('06','35','36','38','80','21','22','23','07','08','81','30','60','61', '95','96','97','98','99')
        AND TL.DELTD <>'Y'
        GROUP BY TL.TXNUM,TL.TXDATE
    ) TR, CFMAST CF, CFMAST CF2, DEPOSIT_MEMBER DEP, DEPOSIT_MEMBER DEP2, VW_CAMAST_ALL CA, SBSECURITIES SB
    WHERE TR.CUSTODYCD = CF.CUSTODYCD
    AND TR.CUSTODYCD2 =  CF2.CUSTODYCD(+)
    AND SUBSTR(TR.CUSTODYCD,1,3) = DEP.SHORTNAME(+)
    AND TR.TOMEMCUS = DEP2.DEPOSITID(+)
    AND TR.CAMASTID=CA.CAMASTID
    AND CA.CODEID = SB.CODEID
    UNION ALL
    SELECT SB.SYMBOL, CA.OPTSYMBOL, CA.ISINCODE,TR.CUSTODYCD,TR.ISSNAME,CF.FULLNAME,CF.ADDRESS,
        (CASE WHEN CF.COUNTRY = '234' THEN CF.IDCODE ELSE CF.TRADINGCODE END) LICENSE,
        TO_CHAR((CASE WHEN CF.COUNTRY = '234' THEN CF.IDDATE ELSE CF.TRADINGCODEDT END),'DD/MM/RRRR') IDDATE,
        CF.IDPLACE,TR.COUNTRY, NVL(DEP.FULLNAME,'') TVLKNAME,
        TR.CUSTODYCD2,TR.TOMEMCUS,NVL(CF2.FULLNAME,'') FULLNAME2, NVL(CF2.ADDRESS,'') ADDRESS2,
        (CASE WHEN NVL(CF2.COUNTRY,'') = '234' THEN NVL(CF2.IDCODE,'') ELSE NVL(CF2.TRADINGCODE,'') END) LICENSE2,
        TO_CHAR((CASE WHEN NVL(CF2.COUNTRY,'') = '234' THEN NVL(CF2.IDDATE,'') ELSE NVL(CF2.TRADINGCODEDT,'') END),'DD/MM/RRRR') IDDATE2,
        NVL(CF2.IDPLACE,'') IDPLACE2, TR.COUNTRY2, NVL(DEP2.FULLNAME,'') TVLKNAME2,
        TR.DES, TR.AMT, TR.MANT, TR.RAMT,
         0 NUOC_NGOAI, 0 TU_DOANH, 0 TRONG_NUOC, TOSYMBOL, TOISSNAME, TR.TXDATE, PLSENT SENDTO
    FROM (
        SELECT TL.TXNUM,TL.TXDATE,
            MAX(DECODE(FLD.FLDCD,'06',CVALUE,NULL)) CAMASTID, --M?KQ
            MAX(DECODE(FLD.FLDCD,'35',CVALUE,NULL)) SYMBOL,-- B?CHUYEN
            MAX(DECODE(FLD.FLDCD,'36',CVALUE,NULL)) CUSTODYCD,
            MAX(DECODE(FLD.FLDCD,'79',CVALUE,NULL)) ISSNAME,
            MAX(DECODE(FLD.FLDCD,'80',CVALUE,NULL)) COUNTRY,
            MAX(DECODE(FLD.FLDCD,'21',NVALUE,NULL)) AMT,
            MAX(DECODE(FLD.FLDCD,'22',NVALUE,NULL)) MANT,
            MAX(DECODE(FLD.FLDCD,'23',NVALUE,NULL)) RAMT,
            MAX(DECODE(FLD.FLDCD,'38',CVALUE,NULL)) CUSTODYCD2,
            MAX(DECODE(FLD.FLDCD,'08',CVALUE,NULL)) TOMEMCUS,
            MAX(DECODE(FLD.FLDCD,'81',CVALUE,NULL)) COUNTRY2,
            MAX(DECODE(FLD.FLDCD,'60',CVALUE,NULL)) TOSYMBOL,
            MAX(DECODE(FLD.FLDCD,'61',CVALUE,NULL)) TOISSNAME,
            MAX(DECODE(FLD.FLDCD,'30',CVALUE,NULL)) DES--DIENGIAI
        FROM VW_TLLOG_ALL TL, VW_TLLOGFLD_ALL FLD
        WHERE TL.TXNUM=FLD.TXNUM
        AND TL.TXDATE=FLD.TXDATE
        AND TL.TXDATE >=TO_DATE(F_DATE,'DD/MM/YYYY')
        AND TL.TXDATE <=TO_DATE(T_DATE,'DD,MM,YYYY')
        AND TL.TLTXCD IN ('3382')
        AND FLD.FLDCD IN ('06','35','36','79','80','21','22','23','38','08','81','30','60','61')
        AND TL.DELTD <>'Y'
        GROUP BY TL.TXNUM,TL.TXDATE
    ) TR, CFMAST CF, CFMAST CF2, DEPOSIT_MEMBER DEP, DEPOSIT_MEMBER DEP2, VW_CAMAST_ALL CA, SBSECURITIES SB
    WHERE TR.CUSTODYCD = CF.CUSTODYCD
    AND TR.CUSTODYCD2 =  CF2.CUSTODYCD(+)
    AND SUBSTR(TR.CUSTODYCD,1,3) = DEP.DEPOSITID(+)
    AND SUBSTR(TR.CUSTODYCD2,1,3) = DEP2.DEPOSITID(+)
    AND TR.CAMASTID=CA.CAMASTID
    AND CA.CODEID = SB.CODEID
) A,(select CF.*, allcode.cdcontent quoc_gia 
from VW_CFMAST_M CF, allcode 
where allcode.cdname = 'COUNTRY' and allcode.cdval = CF.country and allcode.cdtype = 'CF') CF1
,(select CF.*, allcode.cdcontent quoc_gia 
from VW_CFMAST_M CF, allcode 
where allcode.cdname = 'COUNTRY' and allcode.cdval = CF.country and allcode.cdtype = 'CF') CF2
WHERE A.CUSTODYCD=CF1.CUSTODYCD_ORG
AND A.CUSTODYCD2=CF2.CUSTODYCD_ORG (+);




EXCEPTION
   WHEN OTHERS
   THEN

      RETURN;
End;
/
