SET DEFINE OFF;DELETE FROM CMDMENU WHERE 1 = 1 AND NVL(PRID,'NULL') = NVL(NULL,'NULL');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('000000', NULL, 1, 'N', 'P', NULL, NULL, NULL, 'Hệ thống', 'System common', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('100000', NULL, 1, 'N', 'P', NULL, NULL, NULL, 'Khách hàng', 'Customer', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('200000', NULL, 1, 'N', 'P', NULL, NULL, NULL, 'Công ty', 'Company', 'YYYYYYYYYYN', NULL);COMMIT;