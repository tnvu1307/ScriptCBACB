SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD8822','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD8822', 'View receive money(wait for 8822)', 'View receive money(wait for 8822)', 'SELECT * FROM (SELECT SCHD.AUTOID,GETDUEDATE(SCHD.TXDATE,SCHD.CLEARCD,SYM.TRADEPLACE,SCHD.CLEARDAY) GETDUEDATE, (CASE WHEN SCHD.DUETYPE=''RS'' OR SCHD.DUETYPE=''SS'' THEN ''SE'' ELSE ''CI'' END) MODCODE, SCHD.DUETYPE,
SYM.SYMBOL, SYM.CODEID, SYM.PARVALUE,0 VATAMT, SCHD.AFACCTNO, SCHD.AFACCTNO CIACCTNO, SCHD.AFACCTNO || SCHD.CODEID SEACCTNO,
A1.CDCONTENT DESC_DUETYPE,A2.CDCONTENT DESC_CLEARCD,A3.CDCONTENT DESC_STATUS,A4.CDCONTENT DESC_DELTD,
(CASE WHEN (SCHD.AMT + (OD.FEEACR-OD.FEEAMT) - (OD.SECUREDAMT-OD.RLSSECURED))>0 THEN (SCHD.AMT + (OD.FEEACR-OD.FEEAMT) - (OD.SECUREDAMT-OD.RLSSECURED)) ELSE 0 END) CRSECUREDAMT,
SCHD.STATUS, SCHD.TXDATE, SCHD.CLEARCD, SCHD.CLEARDAY, SCHD.AMT, SCHD.AMT TRFAMT, ROUND(SCHD.AAMT-SCHD.PAIDAMT,0) AAMT,ROUND(SCHD.FAMT-SCHD.PAIDFEEAMT,0) FAAMT, SCHD.QTTY, SCHD.AQTTY, SCHD.FAMT, round(SCHD.AMT/SCHD.QTTY,4) MATCHPRICE,
SCHD.ORGORDERID ORDERID, OD.SECUREDAMT, OD.RLSSECURED, OD.FEEAMT,(CASE WHEN OD.EXECTYPE=''MS'' THEN 1 ELSE 0 END) ISMORTAGE,CD.CDCONTENT MORTAGE, OD.FEEACR, OD.SECUREDAMT-OD.RLSSECURED AVLSECUREDAMT, ROUND(OD.FEEACR-OD.FEEAMT,0) AVLFEEAMT,
''Nhan tien ban chung khoan '' ||  SYM.SYMBOL ||'' So hieu lenh '' ||od.orderid ||'' Ban ngay '' || to_char(od.txdate,''DD/MM/YYYY'') DESCRIPTION
FROM AFMAST AF, CFMAST CF, STSCHD SCHD, ODMAST OD, SBSECURITIES SYM, ALLCODE A1,ALLCODE A2,ALLCODE A3,ALLCODE A4,SYSVAR,ALLCODE CD
WHERE SCHD.AFACCTNO = AF.ACCTNO AND AF.CUSTID = CF.CUSTID AND SCHD.ORGORDERID=OD.ORDERID AND SYM.CODEID=SCHD.CODEID
AND SCHD.DUETYPE=''RM'' AND SCHD.STATUS=''N'' AND SCHD.DELTD <>''Y''
AND A1.CDTYPE = ''OD'' AND A1.CDNAME = ''DUETYPE'' AND A1.CDVAL= SCHD.DUETYPE
AND A2.CDTYPE = ''OD'' AND A2.CDNAME = ''CLEARCD'' AND A2.CDVAL= SCHD.CLEARCD
AND A3.CDTYPE = ''OD'' AND A3.CDNAME = ''CALENDARSTATUS'' AND A3.CDVAL= SCHD.STATUS
AND A4.CDTYPE = ''SY'' AND A4.CDNAME = ''YESNO'' AND A4.CDVAL= SCHD.DELTD
AND SYSVAR.GRNAME=''SYSTEM'' AND SYSVAR.VARNAME=''CURRDATE''
AND GETDUEDATE(SCHD.TXDATE,SCHD.CLEARCD,SYM.TRADEPLACE,SCHD.CLEARDAY)=TO_DATE(SYSVAR.VARVALUE,''dd/MM/YYYY'')
AND CD.CDTYPE=''SY'' and CD.CDNAME=''YESNO'' AND CD.CDVAL=(CASE WHEN OD.exectype=''MS'' THEN ''Y'' ELSE ''N'' END)
ORDER BY TXDATE, MODCODE) WHERE 0=0 ', 'OD.ODMAST', NULL, NULL, '8822', NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;