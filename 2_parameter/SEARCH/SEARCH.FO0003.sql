SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('FO0003','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('FO0003', 'So phu tai khoan chung khoan', 'Extra book of stock acocunt', 'SELECT DISTINCT LG.TXDATE, LG.TXNUM, LG.TXTIME, LG.TLTXCD, LG.TXDESC, SYM.SYMBOL, LG.MSGAMT, LG.MSGACCT, TRF.NAMT TRFVAL
FROM AFMAST AF, SBSECURITIES SYM, SEMAST MST, SETRAN TRF, TLLOG LG, APPTX TX
WHERE AF.ACCTNO=MST.AFACCTNO AND MST.ACCTNO=TRF.ACCTNO AND TRF.TXDATE=LG.TXDATE AND TRF.TXNUM=LG.TXNUM AND LG.DELTD<>''Y''
AND SYM.CODEID=MST.CODEID AND TX.APPTYPE=''SE'' AND TX.FIELD=''TRADE'' AND TX.TXCD=TRF.TXCD AND AF.ACCTNO=''<$AFACCTNO>''
UNION ALL
SELECT DISTINCT LG.TXDATE, LG.TXNUM, LG.TXTIME, LG.TLTXCD, LG.TXDESC, SYM.SYMBOL, LG.MSGAMT, LG.MSGACCT, TRF.NAMT TRFVAL
FROM AFMAST AF, SBSECURITIES SYM, SEMAST MST, SETRANA TRF, TLLOGALL LG, APPTX TX
WHERE AF.ACCTNO=MST.AFACCTNO AND MST.ACCTNO=TRF.ACCTNO AND TRF.TXDATE=LG.TXDATE AND TRF.TXNUM=LG.TXNUM AND LG.DELTD<>''Y''
AND SYM.CODEID=MST.CODEID AND TX.APPTYPE=''SE'' AND TX.FIELD=''TRADE'' AND TX.TXCD=TRF.TXCD AND AF.ACCTNO=''<$AFACCTNO>''', 'USERLOGIN', NULL, 'TXDATE, TXNUM', NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;