SET DEFINE OFF;DELETE FROM GRMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('RE.REGRP','NULL');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('RE', 'RE.REGRP', 0, 'MAIN', 'N', 'NNNNNNNN', 'TT chung', 'General', 'N', '', 'N');Insert into GRMASTER   (MODCODE, OBJNAME, ODRNUM, GRNAME, GRTYPE, GRBUTTONS, GRCAPTION, EN_GRCAPTION, CAREBYCHK, SEARCHCODE, ISUSER_SEARCHCODE) Values   ('RE', 'RE.REGRP', 1, 'REGRPLEADERS', 'G', 'EEEENNNN', 'Quy định trưởng nhóm phụ', 'Manage group vice leader ', 'N', 'REGRPLEADERS', 'N');COMMIT;