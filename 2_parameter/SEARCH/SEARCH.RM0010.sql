SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RM0010','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RM0010', 'Hold thiếu chứng khoán', 'Hold stock', 'select *From v_rm0010 where 0 = 0', 'RM0010', NULL, NULL, NULL, 0, 1000, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;