SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('598.005.CAINFO','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('598.005.CAINFO', 'Xác nhận danh sách phân bổ quyền', '598', 'Y', 'REQ', '3335', '', '', '', 'Y', 'Confirm the list of distribution right', 'VSD');COMMIT;