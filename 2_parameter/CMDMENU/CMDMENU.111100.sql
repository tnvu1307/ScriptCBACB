SET DEFINE OFF;

DELETE FROM CMDMENU WHERE 1 = 1 AND NVL(PRID,'NULL') = NVL('111100','NULL');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('111102', '111100', 3, 'N', 'T', 'CF0005', 'CF', '0070', 'Giao dịch', 'Transaction', 'YYYYYYYYYYN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('111103', '111100', 3, 'Y', 'R', 'CF0006', 'CF', 'RPTMASTER', 'Báo cáo', 'Report', 'YYYYYYYYYYN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('111104', '111100', 3, 'Y', 'A', 'CF0007', 'CF', 'CFGENERALVIEW', 'Tra cứu tổng hợp', 'General view', 'YYYYYYYYYYN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('111106', '111100', 3, 'Y', 'A', 'CFIMPORT', 'CF', 'CFIMPORTFILE', 'Import giao dịch theo file', 'Synchronous data from file', 'YYYYYYYYYYN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('111107', '111100', 3, 'Y', 'A', 'CFAPRIMP', 'CF', 'CFAPRIMPORTFILE', 'Duyệt Import giao dịch theo file', 'Approve Synchronous data from file', 'YYYYYYYYYYN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('111110', '111100', 3, 'Y', 'O', '', 'SA', 'TAXTRAN', 'Theo dõi các loại thuế của KH', 'Manage customer charges', 'NYNNYYYNNNN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('111111', '111100', 3, 'Y', 'M', '', 'DD', 'USERLOGIN', 'Thông tin đăng ký dịch vụ trực tuyến', 'Online service registration information', 'YYYYYYYYYYY', '');

COMMIT;