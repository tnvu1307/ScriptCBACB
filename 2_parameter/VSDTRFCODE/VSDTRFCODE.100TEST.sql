SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('100.TEST','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('100.TEST', 'Customize salary', '100', 'Y', 'REQ', '1209', '', '', '', 'Y', 'Customize salary', 'CBP');COMMIT;