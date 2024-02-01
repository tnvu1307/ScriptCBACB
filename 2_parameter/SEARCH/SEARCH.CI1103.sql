SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CI1103','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CI1103', 'Tra cứu lệnh cho phép trả ứng trước (1103)', 'View available order for paid advance payment (1103)', 'SELECT * FROM (SELECT (CASE WHEN ODMAST.exectype=''MS'' THEN 1 ELSE 0 END) ISMORTAGE,CD.CDCONTENT MORTAGE,
STSCHD.AFACCTNO,AMT,QTTY,FULLNAME,CUSTODYCD,SB.SYMBOL,AAMT,ORGORDERID,PAIDAMT,PAIDFEEAMT,
SYSRATE.VARVALUE FEERATE,STSCHD.TXDATE,
''Paid Advanced payment: '' || STSCHD.AFACCTNO || ''.'' || SB.SYMBOL || ''.'' || QTTY || ''.'' || SYSVAR.VARVALUE  DES,
GETDUEDATE(STSCHD.TXDATE,STSCHD.CLEARCD,SB.TRADEPLACE,STSCHD.CLEARDAY) CLEARDATE,
 decode ( GETDUEDATE(STSCHD.TXDATE,STSCHD.CLEARCD,''000'',STSCHD.CLEARDAY)-TO_DATE(SYSVAR.VARVALUE,''DD/MM/YYYY''),0,1,GETDUEDATE(STSCHD.TXDATE,STSCHD.CLEARCD,''000'',STSCHD.CLEARDAY)-TO_DATE(SYSVAR.VARVALUE,''DD/MM/YYYY'')) DAYS,
 ROUND(AAMT-PAIDAMT,0) DEPOAMT ,
 ROUND(AAMT-PAIDAMT,0) MAXDEPOAMT,
 ROUND(STSCHD.FAMT - STSCHD.PAIDFEEAMT - SYSMIN.VARVALUE) FEEMAX
FROM
(SELECT ORGORDERID,TXDATE,MAX(AFACCTNO) AFACCTNO, MAX(CODEID) CODEID, MAX(CLEARDAY) CLEARDAY,MAX(CLEARCD) CLEARCD,SUM(AMT) AMT,SUM(QTTY) QTTY,SUM(FAMT) FAMT,SUM(AAMT) AAMT,SUM(PAIDAMT) PAIDAMT,SUM(PAIDFEEAMT) PAIDFEEAMT
    FROM STSCHD WHERE DELTD <> ''Y'' AND STATUS=''N'' AND DUETYPE=''RM''
    GROUP BY ORGORDERID,TXDATE ) STSCHD,
ODMAST,SYSVAR,SYSVAR SYSRATE,SYSVAR SYSMIN,AFMAST,CFMAST,SBSECURITIES SB,ALLCODE CD
WHERE
AAMT-PAIDAMT>0
AND STSCHD.ORGORDERID=ODMAST.ORDERID
AND SYSVAR.VARNAME=''CURRDATE'' AND SYSVAR.GRNAME=''SYSTEM''
AND SYSRATE.VARNAME=''AINTRATE'' AND SYSRATE.GRNAME=''SYSTEM''
AND SYSMIN.VARNAME=''AMINBAL'' AND SYSMIN.GRNAME=''SYSTEM''
AND AFMAST.ACCTNO=STSCHD.AFACCTNO AND AFMAST.CUSTID=CFMAST.CUSTID
AND SB.CODEID=STSCHD.CODEID
AND CD.CDTYPE=''SY'' and CDNAME=''YESNO'' AND CDVAL=(CASE WHEN ODMAST.exectype=''MS'' THEN ''Y'' ELSE ''N'' END) ) WHERE DAYS>0', 'CIMAST', NULL, NULL, '1103', NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;