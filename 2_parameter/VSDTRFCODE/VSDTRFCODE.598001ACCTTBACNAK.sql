SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('598.001.ACCT//TBAC.NAK','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('598.001.ACCT//TBAC.NAK', 'Từ chối chuyển khoản đóng tài khoản', '598', 'Y', 'CFN', '2290', '', '', '2247', 'Y', '', 'VSD');COMMIT;