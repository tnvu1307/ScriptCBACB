SET DEFINE OFF;DELETE FROM GRMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('FA.FAACCTINVESTRULE','NULL');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('FA', 'FA.FAACCTINVESTRULE', 0, 'MAIN', 'N', 'NNNNNNNN', 'TT chung', 'Common', 'N', '', 'N');COMMIT;