SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('FN.FNMAST','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('FN', 'FN.FNMAST', 'Tài khoản quỹ, ủy thác vốn', 'Fund, trust unit account', 'N', 'N', 'NNNNYYY', 'NET');COMMIT;