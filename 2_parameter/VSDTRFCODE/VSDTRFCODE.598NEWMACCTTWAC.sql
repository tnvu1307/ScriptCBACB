SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('598.NEWM.ACCT//TWAC','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('598.NEWM.ACCT//TWAC', 'Chuyển khoản chứng khoán tất toán không đóng tài khoản', '598', 'Y', 'REQ', '2258', NULL, NULL, NULL, 'Y', NULL, 'VSD');COMMIT;