SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('MT.WCRBLOG','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('MT', 'MT.WCRBLOG', 'Swift detail', 'Swift detail', 'N', 'N', 'NNNNYYY', 'NET');COMMIT;