SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('V_DFMAST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('V_DFMAST', 'Quản lý Deal DF của khách hàng', 'DF Deal Management', 'SELECT * FROM V_DFMAST WHERE 0=0', 'V_DFMAST', 'frmDFMAST', 'ACCTNO DESC', NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;