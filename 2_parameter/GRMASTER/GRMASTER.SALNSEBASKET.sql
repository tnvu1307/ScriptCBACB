SET DEFINE OFF;DELETE FROM GRMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.LNSEBASKET','NULL');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('SA', 'SA.LNSEBASKET', 0, 'MAIN', 'N', 'NNNNNNNN', 'TT chung', 'General', 'N', '', 'N');COMMIT;