SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('548.INST.LINK//598.SETR//TBAC.STCO//DLWM','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('548.INST.LINK//598.SETR//TBAC.STCO//DLWM', 'Từ chối chuyển khoản đóng tài khoản', '548', 'Y', 'CFN', '2290', NULL, NULL, '2247', 'Y', NULL, 'VSD');COMMIT;