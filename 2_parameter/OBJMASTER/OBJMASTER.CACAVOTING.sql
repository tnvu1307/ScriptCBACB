SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CA.CAVOTING','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('CA', 'CA.CAVOTING', 'Vote sự kiện quyền', 'Coporate action voting', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;