SET DEFINE OFF;DELETE FROM CMDMENU WHERE 1 = 1 AND NVL(PRID,'NULL') = NVL('117000','NULL');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('117001', '117000', 3, 'Y', 'O', NULL, 'AP', 'CRPHYSAGREE', 'Quản lý thông tin hợp đồng đặt mua physical', 'Manage physical subscription agreement ', 'NYYYYYYNNYY', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('117003', '117000', 3, 'N', 'T', 'AP0001', 'AP', NULL, 'Giao dịch', 'Transactions', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('117004', '117000', 3, 'Y', 'A', 'GL0015  ', 'AP', 'APGENERALVIEW', 'Tra cứu tổng hợp', 'General view', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('117005', '117000', 3, 'Y', 'R', 'AP0002', 'AP', 'RPTMASTER', 'Báo cáo', 'Report', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('117006', '117000', 3, 'Y', 'A', 'APIMP', 'AP', 'SEIMPORTFILE', 'Import giao dịch theo file', 'Import data from file', 'YYYYYYYYYYN', NULL);COMMIT;