SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.ONLREQUESTLOG','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.ONLREQUESTLOG', 'Tra cứu giao dịch online', 'Look up online transactions', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;