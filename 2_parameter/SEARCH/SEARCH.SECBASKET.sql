SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SECBASKET','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SECBASKET', 'Chứng khoán ký quỹ tài khoản', 'Securities for credit line', 'SELECT TYP.AUTOID, TYP.SYMBOL, TYP.MRRATIORATE, TYP.MRRATIOLOAN, TYP.MRPRICERATE, TYP.MRPRICELOAN FROM SECBASKET TYP WHERE BASKETID=''<$KEYVAL>'' ORDER BY SYMBOL', 'SA.SECBASKET', 'frmSECBASKET', '', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;