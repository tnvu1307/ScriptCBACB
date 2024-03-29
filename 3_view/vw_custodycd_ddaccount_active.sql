SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_CUSTODYCD_DDACCOUNT_ACTIVE
(FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, 
 DESCRIPTION, DDACCTNO)
AS 
SELECT CF.CUSTODYCD FILTERCD, DD.ACCTNO VALUE, DD.ACCTNO VALUECD, DD.REFCASAACCT || ' ' || DD.ccycd || ' ' || ACCOUNTTYPE  DISPLAY,
DD.REFCASAACCT || ' ' || DD.ccycd || ' ' || ACCOUNTTYPE  EN_DISPLAY, CF.FULLNAME DESCRIPTION, DD.ACCTNO DDACCTNO
FROM CFMAST CF, DDMAST DD
WHERE CF.CUSTID=DD.CUSTID
AND DD.STATUS <> 'C'
/
