SET DEFINE OFF;DELETE FROM GRMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('DD.ONUSERINFO','NULL');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('DD', 'DD.ONUSERINFO', 0, 'MAIN', 'N', 'NNNNNNNN', 'TT Chung', 'Common', 'N', 'ONUSERINFO', 'N');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('DD', 'DD.ONUSERINFO', 1, 'MONEYACCOUNT', 'G', 'EEEENNNN', 'TT tài khoản tiền', 'Money Account', 'N', 'MONEYACCOUNT', 'Y');COMMIT;