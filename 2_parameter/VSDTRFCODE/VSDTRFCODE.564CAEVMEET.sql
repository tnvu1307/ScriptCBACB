SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('564.CAEV//MEET','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('564.CAEV//MEET', 'Thông báo họp đại hội cổ đông thường niên', '564', 'Y', 'INF', NULL, NULL, NULL, NULL, 'Y', 'Notice annual general meeting', 'VSD');COMMIT;