SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('564.CAEV//INTR','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('564.CAEV//INTR', 'Thông báo thanh toán lãi trái phiếu', '564', 'Y', 'INF', NULL, NULL, NULL, NULL, 'Y', 'Payment of bond interest', 'VSD');COMMIT;