SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE2008','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE2008', 'Thông tin số dư tài khoản lưu ký chứng khoán (hàng tháng) tổng hợp với VSD (đối chiếu)', 'Coporate action all', ' ', 'SE0087', 'frmSE0087', '', '', NULL, 5000, 'N', 1, 'NYNNYYYNNY', 'Y', 'T', '', 'N', '');COMMIT;