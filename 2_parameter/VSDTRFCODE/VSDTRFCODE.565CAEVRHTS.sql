SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('565.CAEV//RHTS','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('565.CAEV//RHTS', 'Đăng ký quyền mua', '565', 'Y', 'REQ', '3357', '', '', '', 'Y', 'Request for the right issue subscription', 'VSD');COMMIT;