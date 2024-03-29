SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_AF_SUBACCOUNT
(FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, 
 DESCRIPTION, GROUPLEADER, CAREBY, CUSTODYCD)
AS 
SELECT AF.ACCTNO FILTERCD, AF.ACCTNO VALUE,
AF.ACCTNO VALUECD, AF.ACCTNO || ': ' || AFT.TYPENAME DISPLAY,
AF.ACCTNO || ': ' || AFT.TYPENAME EN_DISPLAY,
CF.FULLNAME DESCRIPTION,AF.GROUPLEADER, AF.CAREBY,cf.custodycd
FROM CFMAST CF, AFMAST AF, AFTYPE AFT
WHERE CF.CUSTID=AF.CUSTID
AND AF.ACTYPE=AFT.ACTYPE
AND AF.STATUS NOT LIKE 'C'
UNION ALL
SELECT AF.ACCTNO FILTERCD, AF2.ACCTNO VALUE,
AF2.ACCTNO VALUECD, AF2.ACCTNO || ': ' || AFT.TYPENAME DISPLAY,
AF2.ACCTNO || ': ' || AFT.TYPENAME EN_DISPLAY,
CF.FULLNAME DESCRIPTION,AF2.GROUPLEADER, AF2.CAREBY,cf.custodycd
FROM CFMAST CF, AFMAST AF,AFMAST AF2, AFTYPE AFT
WHERE CF.CUSTID=AF.CUSTID
AND AF2.ACTYPE=AFT.ACTYPE AND AF2.CUSTID = CF.CUSTID
AND AF.STATUS NOT LIKE 'C' AND AF2.STATUS NOT LIKE 'C'
AND AF2.ACCTNO <> AF.ACCTNO
/
