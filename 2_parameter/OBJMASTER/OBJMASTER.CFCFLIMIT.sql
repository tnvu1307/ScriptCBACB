SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF.CFLIMIT','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('CF', 'CF.CFLIMIT', 'NH - Quản lý hạn mức tín dụng chung', 'Common credit limit of the bank', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;