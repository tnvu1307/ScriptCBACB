SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CRBDEFACCT','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('RM', 'CRBDEFACCT', 'Sửa tài khoản bảng kê', 'Sửa tài khoản bảng kê', 'Y', 'N', 'YYYYYYY', 'NET');COMMIT;