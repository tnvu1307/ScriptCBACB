SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_STRADE_CUSTOMER_PROFILE
(CUSTID, CUSTODYCD, SHORTNAME, FULLNAME, EN_IDTYPE_DESC, 
 IDTYPE_DESC, IDCODE, IDDATE, IDPLACE, IDEXPIRED, 
 ADDRESS, PHONE, MOBILE, FAX, EMAIL, 
 OPNDATE, SEX, DATEOFBIRTH, COUNTRY, CUSTTYPE, 
 TYPEACC)
AS 
SELECT MST.CUSTID, MST.CUSTODYCD, MST.SHORTNAME, MST.FULLNAME,
CD1.EN_CDCONTENT EN_IDTYPE_DESC, CD1.CDCONTENT IDTYPE_DESC, MST.IDCODE, MST.IDDATE, MST.IDPLACE, MST.IDEXPIRED,
MST.ADDRESS, MST.PHONE, MST.MOBILE, MST.FAX, MST.EMAIL , TH.OPNDATE , MST.SEX , MST.dateofbirth, CD2.CDCONTENT COUNTRY,
MST.CUSTTYPE , SUBSTR(MST.CUSTODYCD, 4,1) TYPEACC
FROM CFMAST MST, ALLCODE CD1, ALLCODE CD2,
(select cf.custid , min(cf.opndate) opndate   from cfmast cf , afmast af where af.custid= cf.custid and cf.custodycd is not null group by cf.custid
) TH
WHERE CD1.CDTYPE='CF' AND CD1.CDNAME='IDTYPE' AND MST.IDTYPE=CD1.CDVAL AND CD2.CDNAME='COUNTRY' AND CD2.CDVAL= MST.COUNTRY AND TH.CUSTID = MST.CUSTID
/
