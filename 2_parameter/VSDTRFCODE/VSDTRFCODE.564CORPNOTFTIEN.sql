SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('564.CORP.NOTF.TIEN','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('564.CORP.NOTF.TIEN', 'Thông báo SKQ - Tiền', '564', 'Y', 'REQ', '9013', NULL, NULL, NULL, 'Y', 'Corporate Action Notification - Cash', 'CBP');COMMIT;