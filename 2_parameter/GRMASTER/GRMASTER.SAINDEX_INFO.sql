SET DEFINE OFF;DELETE FROM GRMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.INDEX_INFO','NULL');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('SA', 'SA.INDEX_INFO', 0, 'MAIN', 'N', 'EEEENNNN', 'Index Info', 'Index Info', 'N', 'INDEX_INFO', 'N');COMMIT;