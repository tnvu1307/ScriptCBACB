SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('544.NEWM..SETR//ISSU..OK','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('544.NEWM..SETR//ISSU..OK', 'Thông báo hạch toán tăng tài khoản', '544', 'Y', 'INF', '2245', '', '', '2245', 'Y', 'Notice of increasing balance', 'VSD');COMMIT;