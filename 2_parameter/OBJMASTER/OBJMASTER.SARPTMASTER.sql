SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.RPTMASTER','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.RPTMASTER', 'Quản lý báo cáo và tra cứu', 'Report and view managemnet', 'N', 'N', 'NNNNYYYN', 'NET');COMMIT;