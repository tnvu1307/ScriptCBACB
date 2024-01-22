SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_DDACCOUNT_BYCUSTODY_ACTIVE
(FILTERCD, VALUE, VALUECD, DISPLAY, EN_DISPLAY, 
 DESCRIPTION)
AS 
SELECT DD.CUSTODYCD FILTERCD, DD.ACCTNO VALUE, DD.ACCTNO VALUECD, 
       DD.REFCASAACCT || '-' || DD.CCYCD || '-' || DD.ACCOUNTTYPE DISPLAY,
       DD.REFCASAACCT || '-' || DD.CCYCD || '-' || DD.ACCOUNTTYPE EN_DISPLAY, 
       DD.REFCASAACCT || '-' || DD.CCYCD || '-' || DD.ACCOUNTTYPE DESCRIPTION
FROM DDMAST DD
WHERE DD.STATUS ='A'
ORDER BY ISDEFAULT DESC, AUTOID
/
