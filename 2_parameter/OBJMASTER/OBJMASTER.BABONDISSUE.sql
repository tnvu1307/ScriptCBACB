SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('BA.BONDISSUE','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('BA', 'BA.BONDISSUE', 'Thông tin trái phiếu', 'Bond  information', 'Y', 'N', 'NNNYYYY', 'NET');COMMIT;