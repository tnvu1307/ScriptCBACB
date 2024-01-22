SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_CA3333
(CAMASTID, SYMBOL_ORG, SYMBOL, OPTSYMBOL, CUSTODYCD, 
 CIFID, FULLNAME, TRADE, PBALANCE10, PBALANCE20, 
 QTTYCANCEL, EXPRICE, DESCRIPTION, MAXBALANCE)
AS 
SELECT SUBSTR(CA.CAMASTID,1,4) || '.' || SUBSTR(CA.CAMASTID,5,6) || '.' || SUBSTR(CA.CAMASTID,11,6) CAMASTID,
       SYM_ORG.SYMBOL SYMBOL_ORG, SYM.SYMBOL, OPTSYM.SYMBOL OPTSYMBOL, CF.CUSTODYCD, CF.CIFID, CF.FULLNAME,
       SC.TRADE, SC.PBALANCE - SC.QTTYCANCEL PBALANCE20, SC.PBALANCE - SC.QTTYCANCEL PBALANCE10, SC.QTTYCANCEL,
       CA.EXPRICE, TL.EN_TXDESC DESCRIPTION, SC.PBALANCE + SC.BALANCE + SC.OUTBALANCE - SC.INBALANCE MAXBALANCE
FROM CFMAST CF, AFMAST AF, CAMAST CA, SBSECURITIES SYM, SBSECURITIES OPTSYM, SBSECURITIES SYM_ORG, CASCHD SC,
(
    SELECT * FROM TLTX WHERE TLTXCD='3333'
) TL
WHERE CF.CUSTID = AF.CUSTID
AND SC.AFACCTNO = AF.ACCTNO
AND SC.CAMASTID = CA.CAMASTID
AND NVL(CA.TOCODEID, CA.CODEID) = SYM.CODEID
AND CA.OPTCODEID = OPTSYM.CODEID
AND SYM_ORG.CODEID = CA.CODEID
AND TO_DATE(CA.BEGINDATE,'DD/MM/YYYY') <= TO_DATE(GETCURRDATE,'DD/MM/YYYY')
AND CA.STATUS IN( 'V','M')
AND SC.STATUS IN( 'V','M')
AND SC.PBALANCE - SC.QTTYCANCEL > 0
AND SC.PQTTY > 0
AND CA.CATYPE='014'
/
