SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.TXCHKRULES','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.TXCHKRULES', 'Quy định kiểm tra giao dịch', 'Transaction Checking Rules', 'Y', 'N', 'NNNYYYY', 'NET');COMMIT;