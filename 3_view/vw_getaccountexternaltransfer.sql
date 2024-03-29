SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_GETACCOUNTEXTERNALTRANSFER
(AUTOID, CFCUSTID, CIACCOUNT, CINAME, CUSTID, 
 BANKACC, BANKACNAME, BANKNAME, TYPE, ACNIDCODE, 
 ACNIDDATE, ACNIDPLACE, FEECD, CITYEF, CITYBANK, 
 BANKCODE, AVLCASH, CUSTODYCD, ACCTNO)
AS 
(/*SELECT CFO."AUTOID",CFO."CFCUSTID",CFO."CIACCOUNT",CFO."CINAME",CFO."CUSTID",CFO."BANKACC",CFO."BANKACNAME",CFO."BANKNAME",CFO."TYPE",CFO."ACNIDCODE",CFO."ACNIDDATE",CFO."ACNIDPLACE",CFO."FEECD",CFO."CITYEF",CFO."CITYBANK",CFO."BANKCODE",getbaldefovd(af.acctno) AVLCASH, CF.CUSTODYCD , af.acctno
FROM CFOTHERACC CFO, AFMAST AF,CFMAST CF
WHERE CFO.CFCUSTID = AF.CUSTID AND AF.CUSTID= CF.CUSTID AND TYPE='1'*/
SELECT CFO."AUTOID",CFO."CFCUSTID",CFO."CIACCOUNT",CFO."CINAME",CFO."CUSTID",CFO."BANKACC",
CFO."BANKACNAME",CFO."BANKNAME",CFO."TYPE",CFO."ACNIDCODE",CFO."ACNIDDATE",CFO."ACNIDPLACE",CFO."FEECD",CFO."CITYEF",CFO."CITYBANK",CFO."BANKCODE",getbaldefovd(af.acctno) AVLCASH, CF.CUSTODYCD , af.acctno
FROM CFOTHERACC CFO, AFMAST AF,CFMAST CF
WHERE CFO.CFCUSTID = AF.CUSTID AND AF.CUSTID= CF.CUSTID AND TYPE='1' AND nvl(CFO.DELTD,'N')<>'Y'
union
select 999999 AUTOID,  cf.custid CFCUSTID, '' CIACCOUNT, '' CINAME, cf.CUSTID, af.bankacctno BANKACC,
cf.fullname BANKACNAME,ls.bankname BANKNAME,'1' TYPE,CF.idcode ACNIDCODE,CF.iddate ACNIDDATE,cf.idplace ACNIDPLACE,
'0009' FEECD,ls.regional CITYEF,ls.regional CITYBANK,ls.bankcode BANKCODE,getbaldefovd(af2.acctno) AVLCASH, CF.CUSTODYCD , af2.acctno
from afmast af, cfmast cf,crbbanklist ls, crbbankmap map, afmast af2
where af.custid= cf.custid and (af.corebank ='Y' or af.alternateacct ='Y')
and ls.bankcode= map.bankcode and map.bankid= substr(af.bankacctno,1,3) and af2.custid = cf.custid
)
/
