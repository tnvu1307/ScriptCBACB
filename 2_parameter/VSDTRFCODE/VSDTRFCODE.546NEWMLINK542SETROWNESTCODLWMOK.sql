SET DEFINE OFF;DELETE FROM VSDTRFCODE WHERE 1 = 1 AND NVL(TRFCODE,'NULL') = NVL('546.NEWM.LINK//542.SETR//OWNE.STCO//DLWM.OK','NULL');Insert into VSDTRFCODE   (TRFCODE, DESCRIPTION, VSDMT, STATUS, TYPE, TLTXCD, SEARCHCODE, FILTERNAME, REQTLTXCD, AUTOCONF, EN_DESCRIPTION, BANKCODE) Values   ('546.NEWM.LINK//542.SETR//OWNE.STCO//DLWM.OK', 'Chấp thuận chuyển khoản chứng khoán ra ngoài', '546', 'Y', 'CFO', '2266', 'SE2266', 'CUSTODYCD', '2255', 'Y', NULL, 'VSD');COMMIT;