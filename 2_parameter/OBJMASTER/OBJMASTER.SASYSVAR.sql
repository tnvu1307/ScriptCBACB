SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.SYSVAR','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.SYSVAR', 'Thay đổi tham số hệ thống', 'Change sysvar value', 'N', 'N', 'NNNNYNN', 'NET');COMMIT;