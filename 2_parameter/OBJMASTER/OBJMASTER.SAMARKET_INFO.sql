SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.MARKET_INFO','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.MARKET_INFO', 'Market Info', 'Market Info', 'Y', 'N', 'NNNNYNN', 'NET');COMMIT;