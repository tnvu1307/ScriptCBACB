SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('598.NEWM.ACCT//TBAC','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('598.NEWM.ACCT//TBAC', 'Chuyển khoản toàn bộ CK, đóng tài khoản', '542', 'Y', 'REQ', '2247', '', '', '', 'Y', '', 'VSD');COMMIT;