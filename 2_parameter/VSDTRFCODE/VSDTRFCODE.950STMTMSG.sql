SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('950.STMT.MSG','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('950.STMT.MSG', 'Cash Statement Message', '950', 'Y', 'REQ', '1713', '', '', '', 'Y', 'Statement Message', 'CBP');COMMIT;