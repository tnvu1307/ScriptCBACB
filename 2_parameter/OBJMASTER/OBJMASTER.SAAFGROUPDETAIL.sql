SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.AFGROUPDETAIL','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.AFGROUPDETAIL', 'Chi tiết nhóm Tiểu khoản', 'Group Contract details', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;