SET DEFINE OFF;DELETE FROM GRMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF.CFLNKAP','NULL');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('CF', 'CF.CFLNKAP', 0, 'MAIN', 'N', 'NNNNNNNN', 'Người được ủy quyền', 'Authorised participant', 'N', '', 'N');COMMIT;