SET DEFINE OFF;DELETE FROM GRMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.CRBTRFLOG','NULL');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('SA', 'SA.CRBTRFLOG', 0, 'MAIN', 'N', 'NNNNNNNN', 'TT chung', 'General', 'N', NULL, 'N');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('SA', 'SA.CRBTRFLOG', 1, 'CRBTRFLOGDTL', 'G', 'NNNNNNNN', 'Chi tiết bảng kê', 'Detail list', 'N', 'CRBTRFLOGDTL', 'N');COMMIT;