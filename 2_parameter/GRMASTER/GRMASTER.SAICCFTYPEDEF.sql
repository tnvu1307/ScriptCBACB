SET DEFINE OFF;DELETE FROM GRMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.ICCFTYPEDEF','NULL');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('SA', 'SA.ICCFTYPEDEF', 0, 'MAIN', 'N', 'NNNNNNNN', 'TT chung', 'General', 'N', NULL, 'N');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('SA', 'SA.ICCFTYPEDEF', 1, 'ICCFTIER', 'G', 'EEEENNNN', 'Tham số bậc thang', 'Step parameters', 'N', 'ICCFTIER', 'N');COMMIT;