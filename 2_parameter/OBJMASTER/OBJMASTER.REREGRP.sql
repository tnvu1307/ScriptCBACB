SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('RE.REGRP','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('RE', 'RE.REGRP', 'Quản lý nhóm đại lý/môi giới', 'Group of remisers', 'Y', 'N', 'NNNNYYY', 'NET');COMMIT;