SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.AFGROUPHEADER','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.AFGROUPHEADER', 'Quản lý nhóm Tiểu khoản', 'Group Contract Management', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;