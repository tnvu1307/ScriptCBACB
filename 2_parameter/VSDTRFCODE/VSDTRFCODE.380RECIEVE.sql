SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('380.RECIEVE','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('380.RECIEVE', 'Foreign Exchange Order', '380', 'Y', 'REV', 'RECIEVE', '', '', '', 'Y', 'Foreign Exchange Order', 'CBP');COMMIT;