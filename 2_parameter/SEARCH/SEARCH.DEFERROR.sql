SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('DEFERROR','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('DEFERROR', 'Quản lý mã lỗi do người dùng định nghĩa', 'Error code user define', 'SELECT ERRNUM, ERRDESC, MODCODE, CONFLVL FROM DEFERROR, ALLCODE , ALLCODE A WHERE A.CDTYPE = ''SA''', 'DEFERROR', 'frmDEFERROR', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;