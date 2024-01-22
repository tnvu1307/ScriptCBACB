SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_STSCHD_TDAY
(AUTOID, DUETYPE, DDACCTNO, TXDATE, CLEARDAY, 
 CLEARCD, AMT, QTTY, AFACCTNO, STATUS, 
 DELTD, ORGORDERID, CODEID, PAIDFEEAMT, CLEARDATE, 
 TDAY)
AS 
SELECT STS."AUTOID",STS."DUETYPE",STS.ddacctno,STS."TXDATE",STS."CLEARDAY",
STS."CLEARCD",STS."AMT",STS."QTTY",STS."AFACCTNO",STS."STATUS",
STS."DELTD",STS.ORDERID "ORGORDERID",STS."CODEID",STS."PAIDFEEAMT",
STS."CLEARDATE", STS.CLEARDAY-SP_BD_GETCLEARDAY(STS.CLEARCD, SB.TRADEPLACE, STS.TXDATE, TO_DATE(SYS.VARVALUE,'DD/MM/RRRR')) TDAY 
FROM STSCHD STS, SBSECURITIES SB, SYSVAR SYS
WHERE STS.CODEID = SB.CODEID AND SYS.VARNAME ='CURRDATE'
/
