SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.AFDFBASKET','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.AFDFBASKET', 'Loại hình cầm cố/forward', 'InUsed mortage/forward product', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;