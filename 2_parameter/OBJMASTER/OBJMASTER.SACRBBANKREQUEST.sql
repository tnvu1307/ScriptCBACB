SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.CRBBANKREQUEST','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.CRBBANKREQUEST', 'Tra cứu điện nhận từ ngân hàng', 'Bank request management', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;