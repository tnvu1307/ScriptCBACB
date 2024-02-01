SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('DF2682','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('DF2682', 'Huỷ deal trước khi giải ngân', 'Cancel deal before drawdown', '
SELECT  v.*, (v.dfqtty + v.rcvqtty + v.carcvqtty + v.blockqtty)  SENDQTTY
FROM v_getdealinfo v WHERE  v.status in (''N'',''P'') and  v.dfqtty + v.rcvqtty + v.carcvqtty + v.blockqtty>0
', 'DFMAST', NULL, 'ACCTNO DESC', '2682', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;