SET DEFINE OFF;DELETE FROM OBJMASTER WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('SA.IRRATE','NULL');Insert into OBJMASTER   (MODCODE, OBJNAME, OBJTITLE, EN_OBJTITLE, USEAUTOID, CAREBYCHK, OBJBUTTONS, RUNMOD) Values   ('SA', 'SA.IRRATE', 'Quản lý lịch lãi cài đặt trước', 'Management calendar interest presets', 'N', 'N', 'NNNNYYY', 'NET');COMMIT;