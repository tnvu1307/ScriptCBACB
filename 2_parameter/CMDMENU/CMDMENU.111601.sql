SET DEFINE OFF;DELETE FROM CMDMENU WHERE 1 = 1 AND NVL(PRID,'NULL') = NVL('111601','NULL');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111611', '111601', 4, 'Y', 'O', 'SY2007', 'SA', 'FEEMASTER', 'Biểu phí', 'Fee scheme', 'YYYYYYYNNYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111614', '111601', 4, 'Y', 'O', 'CF0003', 'FA', 'FAACCTMAIN', 'Gán biểu phí cho Fund', 'Add fee scheme for Fund', 'YYYYYYYNNYN', NULL);COMMIT;