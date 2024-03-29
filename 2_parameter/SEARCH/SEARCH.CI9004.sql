SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CI9004','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CI9004', 'Tra cứu số dư bình quân trong tháng', 'View Average balance of month', 'SELECT DT.AFACCTNO,DT.TXDATE,ROUND(DT.CIBALANCE,3) CIBALANCE,ROUND(DT.SEBALANCE,3) SEBALANCE,ROUND(DT.AVRBAL,3) AVRBAL,PERIOD,CF.FULLNAME,CD.CDCONTENT CLASS
FROM ALLCODE CD,CFMAST CF,AFMAST AF,
    (
    SELECT DT.* FROM
    (
    SELECT DT.* FROM (
    SELECT MAX(AFACCTNO) AFACCTNO,MAX(TXDATE) TXDATE,SUM(CIBALANCE)/COUNT(AFACCTNO) CIBALANCE,
    SUM(SEBALANCE)/COUNT(AFACCTNO) SEBALANCE, SUM(AVRBAL)/COUNT(AFACCTNO) AVRBAL,''EOD'' Period FROM
    (SELECT AFACCTNO,TXDATE,CIBALANCE,SEBALANCE,AVRBAL FROM AVRBAL
    UNION ALL
    SELECT CI.AFACCTNO,TO_DATE(SYS.VARVALUE,''DD/MM/YYYY'') TXDATE,
    CI.BALANCE CIBALANCE,DT.SEBALANCE,CI.BALANCE+DT.SEBALANCE AVRBAL
    FROM SYSVAR SYS,CIMAST CI,(SELECT MAX(SE.AFACCTNO) AFACCTNO,SUM(SE.TRADE*SEC.BASICPRICE)  SEBALANCE FROM SEMAST SE,SECURITIES_INFO SEC
    WHERE SEC.CODEID =SE.CODEID  GROUP BY SE.AFACCTNO) DT
    WHERE CI.AFACCTNO=DT.AFACCTNO AND SYS.VARNAME=''CURRDATE'' AND SYS.GRNAME=''SYSTEM''
    ) DT1  GROUP BY AFACCTNO ) DT )DT,
    (
    SELECT OD.AFACCTNO, nvl(SUM(OD.QUOTEPRICE*OD.ORDERQTTY),0) VAL_OD , nvl(SUM(EXECAMT),0) VAL_IO, nvl(SUM(OD.FEEACR),0) FEEACR
    FROM
    (SELECT TXDATE,AFACCTNO,QUOTEPRICE,ORDERQTTY,FEEACR,EXECAMT ,ORDERID FROM ODMASTHIST WHERE DELTD <>''Y'' AND EXECTYPE IN (''NB'',''BC'',''NS'',''SS'',''MS'')
    UNION ALL
SELECT TXDATE,AFACCTNO,QUOTEPRICE,ORDERQTTY,FEEACR,EXECAMT ,ORDERID FROM ODMAST WHERE DELTD <>''Y'' AND EXECTYPE IN (''NB'',''BC'',''NS'',''SS'',''MS''))OD ,
SYSVAR SYS
WHERE SYS.VARNAME=''CURRDATE'' AND SYS.GRNAME=''SYSTEM''
AND OD.TXDATE>=TO_DATE(''01/'' || SUBSTR(SYS.VARVALUE,4,7),''DD/MM/YYYY'')
AND OD.TXDATE<=LAST_DAY(TO_DATE(SYS.VARVALUE,''DD/MM/YYYY''))
GROUP BY OD.AFACCTNO) OD
WHERE DT.AFACCTNO =OD.AFACCTNO(+)
UNION ALL
SELECT AFACCTNO,TXDATE,CIBALANCE,SEBALANCE,AVRBAL,PERIOD FROM AVRBALALL ) DT
WHERE CF.CUSTID =AF.CUSTID AND AF.ACCTNO =DT.AFACCTNO AND CD.CDTYPE=''CF''
AND CD.CDNAME =''CLASS'' AND CD.CDVAL=CF.CLASS', 'CIMAST', NULL, NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;