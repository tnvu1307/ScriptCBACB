SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('545.REV.PAY.CONFIRM','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('545.REV.PAY.CONFIRM', 'Receive Against Payment Confirmation', '545', 'Y', 'REQ', '1710', '', '', '', 'Y', 'Receive Against Payment Confirmation', 'CBP');COMMIT;