SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('EXTREFDEF','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('EXTREFDEF', 'Bảng định nghĩa trường tham chiếu', 'External reference management', 'SELECT AUTOID, OBJNAME, ODRNUM, DEFNAME, CAPTION, EN_CAPTION FROM EXTREFDEF WHERE 0=0 ', 'EXTREFDEF', 'frmEXTREFDEF', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;