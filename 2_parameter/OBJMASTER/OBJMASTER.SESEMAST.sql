SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SE.SEMAST','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SE', 'SE.SEMAST', 'Quản lý tài khoản chứng khoán', 'SE Account management', 'N', 'N', 'NNNNYYY', 'NET');COMMIT;