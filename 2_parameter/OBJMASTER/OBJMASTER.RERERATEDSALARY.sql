SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('RE.RERATEDSALARY','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('RE', 'RE.RERATEDSALARY', 'Định mức lương theo GTKL', 'Group of remisers', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;