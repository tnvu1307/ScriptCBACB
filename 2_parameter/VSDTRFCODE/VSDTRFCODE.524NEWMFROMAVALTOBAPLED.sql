SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('524.NEWM.FROM//AVAL.TOBA//PLED','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('524.NEWM.FROM//AVAL.TOBA//PLED', 'Yêu cầu phong tỏa chứng khoán', '524', 'Y', 'REQ', '2236', '', '', '', 'Y', 'Request to block securities', 'VSD');COMMIT;