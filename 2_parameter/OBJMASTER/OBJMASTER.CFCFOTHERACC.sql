SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF.CFOTHERACC','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('CF', 'CF.CFOTHERACC', 'Đăng ký thông tin chuyển tiền trực tuyến', 'Online cash transfer', 'N', 'N', 'NNNYYYY', 'NET');COMMIT;