SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('FACFFEEEXPMAP','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('FACFFEEEXPMAP', 'Giao dịch', 'Transaction mapping', 'SELECT MST.AUTOID, 
MST.REFAUTOID, MST.TLTXCD, MST.AMTEXP, MST.REFFIELD 
FROM CFFEEEXPMAP MST WHERE MST.REFAUTOID=''<$KEYVAL>'' ORDER BY AUTOID
', 'FA.CFFEEEXPMAP', 'frmCFFEEEXPMAP', NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;