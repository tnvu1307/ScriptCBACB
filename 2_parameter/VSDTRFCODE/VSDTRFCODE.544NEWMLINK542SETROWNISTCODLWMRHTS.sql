SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('544.NEWM.LINK//542.SETR//OWNI.STCO//DLWM.RHTS','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('544.NEWM.LINK//542.SETR//OWNI.STCO//DLWM.RHTS', 'Thông báo chuyển khoản quyền mua cùng TVLK', '544', 'Y', 'INF', '3385', '', '', '3358', 'Y', 'Notice of transferring right issue (Internal Account Transfer)', 'VSD');COMMIT;