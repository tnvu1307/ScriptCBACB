SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('542.NEWM.CLAS//PEND.SETR//TRAD.STCO//PHYS','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('542.NEWM.CLAS//PEND.SETR//TRAD.STCO//PHYS', 'Yêu cầu rút lưu ký chứng khoán WFT', '542', 'Y', 'REQ', '2292', '', '', '', 'Y', '', 'VSD');COMMIT;