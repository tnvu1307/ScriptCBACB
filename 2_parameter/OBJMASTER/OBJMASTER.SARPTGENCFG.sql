SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.RPTGENCFG','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.RPTGENCFG', 'Quản lý cài đặt gen báo cáo tự động', 'Set up automatically general reports', 'N', 'N', 'NNNYYYY', 'DB');COMMIT;