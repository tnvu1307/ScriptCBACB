SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF.CFAFTRDLNK','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('CF', 'CF.CFAFTRDLNK', 'Tài khoản đầu tư', 'Trader account', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;