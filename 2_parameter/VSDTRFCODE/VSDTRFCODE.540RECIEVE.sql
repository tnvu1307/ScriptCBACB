SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('540.RECIEVE','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('540.RECIEVE', 'Receiver free for securities', '540', 'Y', 'REV', 'RECIEVE', '', '', '', 'Y', 'Receiver free for securities', 'CBP');COMMIT;