SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('598.005.TRADE','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('598.005.TRADE', 'Xác nhận kết quả giao dịch', '598', 'Y', 'REQ', '1515', '', '', '', 'Y', 'Confirm the trading result', 'VSD');COMMIT;