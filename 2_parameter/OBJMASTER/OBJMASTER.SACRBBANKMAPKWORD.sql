SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.CRBBANKMAPKWORD','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.CRBBANKMAPKWORD', 'Quản lý Mapping', 'Mapping management', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;