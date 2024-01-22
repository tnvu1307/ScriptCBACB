SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('TD1620','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('TD1620', 'Rút tiết kiệm linh hoạt', 'Term deposit flexible withdrawal', 'SELECT MST.ACCTNO, MST.AFACCTNO, CF.CUSTODYCD, CF.FULLNAME,
MST.ORGAMT, MST.BALANCE, MST.BALANCE avlBALANCE, MST.PRINTPAID, MST.INTNMLACR, MST.INTPAID, MST.TAXRATE, MST.BONUSRATE, MST.INTRATE, MST.TDTERM, MST.OPNDATE, MST.FRDATE, MST.TODATE,
MST.BALANCE-MST.MORTGAGE AVLWITHDRAW, MST.MORTGAGE,
A0.CDCONTENT DESC_TDSRC, A1.CDCONTENT DESC_AUTOPAID, A2.CDCONTENT DESC_BREAKCD, A3.CDCONTENT DESC_SCHDTYPE, A4.CDCONTENT DESC_TERMCD, A5.CDCONTENT DESC_STATUS,
A6.cdcontent BUYINGPOWER,MST.ODAMT, floor(MST.ODINTACR) ODINTACR
FROM TDMAST MST, AFMAST AF, CFMAST CF, TDTYPE TYP, ALLCODE A0, ALLCODE A1, ALLCODE A2, ALLCODE A3, ALLCODE A4, ALLCODE A5, SYSVAR,
ALLCODE A6
WHERE MST.ACTYPE=TYP.ACTYPE AND MST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND SYSVAR.VARNAME=''BUSDATE''
AND MST.DELTD<>''Y'' AND MST.status in (''N'',''A'')
AND A0.CDTYPE=''TD'' AND A0.CDNAME=''TDSRC'' AND MST.TDSRC=A0.CDVAL
AND A1.CDTYPE=''SY'' AND A1.CDNAME=''YESNO'' AND MST.AUTOPAID=A1.CDVAL
AND A2.CDTYPE=''SY'' AND A2.CDNAME=''YESNO'' AND MST.BREAKCD=A2.CDVAL
AND A4.CDTYPE=''TD'' AND A4.CDNAME=''TERMCD'' AND MST.TERMCD=A4.CDVAL
AND A5.CDTYPE=''TD'' AND A5.CDNAME=''STATUS'' AND MST.STATUS=A5.CDVAL
AND A3.CDTYPE=''TD'' AND A3.CDNAME=''SCHDTYPE'' AND MST.SCHDTYPE=A3.CDVAL
AND A6.CDTYPE=''SY'' AND A6.CDNAME=''YESNO'' AND MST.BUYINGPOWER=A6.CDVAL
', 'TDMAST', 'frmTDMAST', '', '1620', 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;