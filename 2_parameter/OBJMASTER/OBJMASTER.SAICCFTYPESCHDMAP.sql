SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.ICCFTYPESCHDMAP','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.ICCFTYPESCHDMAP', 'Gán lịch biểu lãi tiền gửi với loại hình tiền gửi', 'Gán lịch biểu lãi tiền gửi với loại hình tiền gửi', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;