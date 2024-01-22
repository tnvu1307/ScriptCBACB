SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_GL_REGR_OD0006
(CUSTODYCD, FULLNAME, TYPEGR, RE_FRDATE, RE_TODATE)
AS 
SELECT cf.custodycd, cf.fullname
, CASE WHEN RETYPE.actype IN ('1000','1001') THEN 'SALE'
       WHEN RETYPE.actype IN ('1002') THEN 'TC'
       WHEN RETYPE.actype IN ('1003') THEN 'CTV'
       WHEN RETYPE.actype IN ('1004') THEN 'DHT'
       WHEN RETYPE.actype IN ('1111','1112') THEN 'MGA'
       WHEN RETYPE.actype IN ('1012') THEN 'KHN'
  END TYPEGR,
 re.frdate re_frdate, nvl(re.clstxdate-1, re.todate) re_todate
FROM reaflnk re, retype,cfmast cf
WHERE SUBSTR(RE.reacctno,11)=RETYPE.actype
AND retype.rerole ='RM'
AND re.afacctno = cf.custid




-- End of DDL Script for View HOSTBSC.VW_GL_REGR
/
