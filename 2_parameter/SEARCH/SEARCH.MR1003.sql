SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR1003','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR1003', 'Danh sách nhóm tiểu khoản cần xử lý bán tài sản', 'View margin account group in liquid status', 'select * from vw_mr1003 where 0=0', 'MR1003', 'frmMarginInfo', NULL, 'EXEC', NULL, 5000, 'N', 1, 'NYNNYYYNYN', 'Y', 'T', NULL, 'N', NULL);COMMIT;