SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('598.007.CHAN.','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('598.007.CHAN.', 'Thông báo mã chứng khoán chuyển sàn', '598', 'Y', 'INF', NULL, NULL, NULL, NULL, 'Y', 'Notice trading platform shifting', 'VSD');COMMIT;