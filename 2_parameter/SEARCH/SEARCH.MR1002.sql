SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR1002','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR1002', 'Danh sách các nhóm tiểu khoản cần call margin hoặc đến hạn', 'View margin account group in maintanance status', 'select * from vw_mr1002 where 0=0', 'MR1002', 'frmMarginInfo', NULL, NULL, NULL, 5000, 'N', 1, 'NYNNYYYYYN', 'Y', 'T', NULL, 'N', NULL);COMMIT;