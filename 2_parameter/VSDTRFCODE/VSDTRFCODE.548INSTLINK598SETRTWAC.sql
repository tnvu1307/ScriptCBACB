SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('548.INST.LINK//598.SETR//TWAC.','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('548.INST.LINK//598.SETR//TWAC.', 'Từ chối chuyển khoản chứng khoán tất toán không đóng tài khoản', '548', 'Y', 'CFN', '2265', '', '', '2255', 'Y', '', 'VSD');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('548.INST.LINK//598.SETR//TWAC.', 'Từ chối chuyển khoản chứng khoán tất toán không đóng tài khoản', '548', 'Y', 'CFN', '', '', '', '2258', 'Y', '', 'VSD');COMMIT;