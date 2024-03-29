SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_CA3302_DEL_N
(AUTOID, BALANCE, RQTTY, PBALANCE, AFACCTNO, 
 CAMASTID, CATYPE, CODEID, EXCODEID, QTTY, 
 AMT, AQTTY, NMQTTY, MQTTY, AAMT, 
 SYMBOL, SYMBOLDIS, STATUS, SEACCTNO, EXSEACCTNO, 
 PARVALUE, EXPARVALUE, REPORTDATE, ACTIONDATE, DESCRIPTION, 
 CUSTODYCD, FULLNAME, IDCODE, ADDRESS, ISRIGHTOFF, 
 AFSTATUS, INQTTY, REGISQTTY, ISRECEIVE, SENDQTTY, 
 SENDPBALANCE, SENDAMT, SENDRQTTY, ISINCODE, CASTATUS, 
 CATYPEVAL, DELTD)
AS 
SELECT
CA.AUTOID, CA.TRADE BALANCE,CA.RQTTY,CA.PBALANCE,CA.AFACCTNO, SUBSTR(CA.CAMASTID,1,4) ||
'.' || SUBSTR(CA.CAMASTID,5,6) || '.' ||
SUBSTR(CA.CAMASTID,11,6) CAMASTID, A0.CDCONTENT CATYPE, CA.CODEID, CA.EXCODEID,
CA.QTTY, CA.AMT, CA.AQTTY,CA.NMQTTY,(CASE WHEN camast.catype='014' THEN CA.qtty ELSE 0 END) MQTTY,
(CASE WHEN camast.catype='014' THEN((CA.qtty +ca.cutqtty+ca.sendqtty  - CA.NMQTTY-CA.INQTTY) * CAMAST.EXPRICE)ELSE 0 END) AAMT,
(CASE WHEN nvl(CAMAST.TOCODEID,'A') = 'A' THEN sym.symbol ELSE symto.symbol END ) SYMBOL,
SYM.SYMBOL SYMBOLDIS, A1.CDCONTENT STATUS,
CA.AFACCTNO || (CASE WHEN CAMAST.ISWFT='Y' THEN (CASE WHEN nvl(CAMAST.TOCODEID,'A') = 'A' THEN (SELECT CODEID FROM SBSECURITIES WHERE REFCODEID =SYM.CODEID) ELSE (SELECT CODEID FROM SBSECURITIES WHERE REFCODEID =SYMTO.CODEID) END)
 ELSE (CASE WHEN nvl(CAMAST.TOCODEID,'A') = 'A' THEN CAMAST.CODEID ELSE CAMAST.TOCODEID END ) END)  SEACCTNO,CA.AFACCTNO
|| (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID
ELSE CAMAST.EXCODEID END) EXSEACCTNO,
SYM.PARVALUE PARVALUE, EXSYM.PARVALUE EXPARVALUE,
CAMAST.REPORTDATE REPORTDATE, CAMAST.ACTIONDATE  ,
camast.description,cf.custodycd,cf.fullname,cf.idcode,cf.address,
decode (camast.catype, '014', 0, 1) ISRIGHTOFF,
A3.CDCONTENT AFSTATUS,
CA.INQTTY,
(CASE WHEN camast.catype IN ('023','014') THEN (CA.QTTY+ca.cutqtty+ca.sendqtty-CA.INQTTY) ELSE 0 END )REGISQTTY,
A4. CDCONTENT ISRECEIVE,
(CASE WHEN camast.catype  NOT IN ('005','006','022') THEN (ca.sendqtty+ca.cutqtty) ELSE 0 END ) sendqtty,
 (ca.sendpbalance+ca.cutpbalance) sendpbalance,
(ca.sendamt+ca.cutamt) sendamt,
(CASE WHEN camast.catype   IN ('005','006','022') THEN (ca.sendqtty+ca.cutqtty) ELSE 0 END ) sendRqtty, CAMAST.ISINCODE,
CAMAST.status CASTATUS,A0.CDVAL CATYPEVAL,camast.deltd
FROM CASCHD CA, SBSECURITIES SYM,SBSECURITIES SYMTO, SBSECURITIES EXSYM,
ALLCODE A0, ALLCODE A1, CAMAST ,AFMAST AF , CFMAST CF, ALLCODE A3,allcode a4
WHERE A0.CDTYPE = 'CA' AND A0.CDNAME = 'CATYPE' AND A0.CDVAL = CAMAST.CATYPE
AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND A1.CDVAL = CA.STATUS
AND A3.CDTYPE = 'CF' AND A3.CDNAME = 'STATUS' AND A3.CDVAL = AF.STATUS
AND A4.CDTYPE = 'SY' AND A4.CDNAME = 'YESNO' AND A4.CDVAL = CA.ISRECEIVE
AND CA.AFACCTNO = AF.ACCTNO AND AF.CUSTID =CF.CUSTID
AND CA.CAMASTID = CAMAST.CAMASTID
AND camast.codeid=sym.codeid AND SYMTO.CODEID=(CASE WHEN nvl(CAMAST.TOCODEID,'A') <> 'A' THEN CAMAST.TOCODEID ELSE CAMAST.CODEID END)
AND CA.DELTD ='N'
AND EXSYM.CODEID = (CASE WHEN CAMAST.EXCODEID IS NULL THEN CAMAST.CODEID ELSE CAMAST.EXCODEID END)
/
