SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('FA.SBACTIMST','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('FA', 'FA.SBACTIMST', 'Lưu trữ thông tin hoạt động', 'Lưu trữ thông tin hoạt động', 'N', 'N', 'NNNYYYY', 'DB');COMMIT;