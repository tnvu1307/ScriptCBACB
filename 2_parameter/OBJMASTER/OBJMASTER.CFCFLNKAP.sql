SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF.CFLNKAP','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('CF', 'CF.CFLNKAP', 'Thông tin người được ủy quyền', 'Authorised participant information', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;