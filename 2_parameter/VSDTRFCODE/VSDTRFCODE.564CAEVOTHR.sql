SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('564.CAEV//OTHR','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('564.CAEV//OTHR', 'Thông báo hoán đổi từ cổ phiếu này sang cổ phiếu khác', '564', 'Y', 'INF', '', '', '', '', 'Y', 'Notice coversion of shares', 'VSD');COMMIT;