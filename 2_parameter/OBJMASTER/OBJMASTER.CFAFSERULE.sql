SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF.AFSERULE','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('CF', 'CF.AFSERULE', 'Chính sách mua/bán', 'Buy/Sell policy', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;