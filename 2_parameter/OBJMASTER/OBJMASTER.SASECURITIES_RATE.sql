SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.SECURITIES_RATE','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.SECURITIES_RATE', 'Tỷ lệ theo bước giá', 'Rate ticksize', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;