SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('564.CAEV//RHTS','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('564.CAEV//RHTS', 'Thông báo quyền mua thêm chứng khoán', '564', 'Y', 'INF', NULL, NULL, NULL, NULL, 'Y', 'Notice the right issue', 'VSD');COMMIT;