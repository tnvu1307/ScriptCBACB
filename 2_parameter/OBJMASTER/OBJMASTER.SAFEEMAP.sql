SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.FEEMAP','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.FEEMAP', 'Bảng định nghĩa phí giao dịch', 'Fee transaction mapping', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;