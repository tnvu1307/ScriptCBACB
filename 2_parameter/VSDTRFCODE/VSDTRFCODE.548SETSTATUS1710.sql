SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('548.SET.STATUS1710','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('548.SET.STATUS1710', 'Settlement Status and Processing Advice', '548', 'Y', 'REJ', '1710', '', '', '', 'Y', 'Settlement Status and Processing Advice', 'CBP');COMMIT;