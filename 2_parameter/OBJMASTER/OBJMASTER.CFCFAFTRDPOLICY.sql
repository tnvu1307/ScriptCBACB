SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF.CFAFTRDPOLICY','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('CF', 'CF.CFAFTRDPOLICY', 'Kế hoạch đầu tư', 'Trader policy', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;