SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('598.007.CAPT.','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('598.007.CAPT.', 'Thông báo mã đợt đăng ký bổ sung - Tăng vốn', '598', 'Y', 'INF', NULL, NULL, NULL, NULL, 'Y', 'Notice of the additional securities registration  - Capital raising', 'VSD');COMMIT;