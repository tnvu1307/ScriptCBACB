SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.CFAFGROUP','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.CFAFGROUP', 'Quản lý nhóm khách hàng, Tiểu khoản', 'CFAFGroup Management', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;