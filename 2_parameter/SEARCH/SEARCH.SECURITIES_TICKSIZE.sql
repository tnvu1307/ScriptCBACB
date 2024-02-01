SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SECURITIES_TICKSIZE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SECURITIES_TICKSIZE', 'Quản lý thang giá của chứng khoán', 'Securities ticksize management', 'SELECT AUTOID, CODEID, SYMBOL, TICKSIZE, FROMPRICE, TOPRICE, CDCONTENT STATUS FROM SECURITIES_TICKSIZE,ALLCODE WHERE CDTYPE = ''SY'' AND CDNAME = ''YESNO'' AND CDVAL=STATUS', 'SECURITIES_TICKSIZE', 'frmSECURITIES_TICKSIZE', 'CODEID', NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;