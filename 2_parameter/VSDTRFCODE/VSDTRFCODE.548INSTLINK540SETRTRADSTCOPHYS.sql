SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('548.INST.LINK//540.SETR//TRAD.STCO//PHYS','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('548.INST.LINK//540.SETR//TRAD.STCO//PHYS', 'Từ chối luu ký chứng khoán', '548', 'Y', 'CFN', '2231', 'SE2231', 'CUSTODYCD', '2241', 'Y', '', 'VSD');COMMIT;