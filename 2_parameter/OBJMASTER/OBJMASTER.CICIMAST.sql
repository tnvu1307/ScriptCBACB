SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CI.CIMAST','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('CI', 'CI.CIMAST', 'Quản lý tài khoản CI', 'CI Account Management', 'N', 'N', 'NNNNYYY', 'NET');COMMIT;