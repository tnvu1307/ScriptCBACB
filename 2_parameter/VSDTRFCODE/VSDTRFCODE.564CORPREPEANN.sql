SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('564.CORP.REPE.ANN','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('564.CORP.REPE.ANN', 'Thong bao SKQ REPE - Thong bao', '564', 'Y', 'REQ', '9022', '', '', '', 'Y', 'Corporate Action Notification REPE - Annoucement', 'CBP');COMMIT;