SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('542.NEWM.CLAS//PEND.SETR//TRAD.STCO//DLWM','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('542.NEWM.CLAS//PEND.SETR//TRAD.STCO//DLWM', 'Yêu cầu chuyển khoản chứng khoán WFT lô lẻ', '542', 'Y', 'REQ', '8815', NULL, NULL, NULL, 'Y', 'Request to transfer odd lot securities', 'VSD');COMMIT;