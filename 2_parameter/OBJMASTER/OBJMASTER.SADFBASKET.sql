SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.DFBASKET','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.DFBASKET', 'Chứng khoán cầm cố/forward', 'Securities for mortgage/forward', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;