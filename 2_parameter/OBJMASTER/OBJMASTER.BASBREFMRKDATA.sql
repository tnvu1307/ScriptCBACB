SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('BA.SBREFMRKDATA','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('BA', 'BA.SBREFMRKDATA', 'Giá thị trường của tài sản', 'Management of market price', 'Y', 'N', 'NNNYYYY', 'NET');COMMIT;