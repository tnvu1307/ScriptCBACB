SET DEFINE OFF;DELETE FROM CMDMENU WHERE 1 = 1 AND NVL(PRID,'NULL') = NVL('111700','NULL');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111701', '111700', 3, 'Y', 'O', 'BA0001', 'BA', 'BONDTYPE', 'Khai báo nguyên tắc định giá', 'Price policy', 'YYYYYYYNNYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111702', '111700', 3, 'Y', 'O', 'BA0002', 'BA', 'BONDTYPEPAY', 'Tạo lịch thanh toán lãi ', 'Create interest payment period', 'YYYYYYYNNYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111703', '111700', 3, 'N', 'T', 'BA0001', 'BA', NULL, 'Giao dịch', 'Transaction', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111704', '111700', 3, 'Y', 'A', 'GL0015  ', 'BA', 'BAGENERALVIEW', 'Tra cứu tổng hợp', 'General view', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111705', '111700', 3, 'Y', 'R', 'BA0005', 'BA', 'RPTMASTER', 'Báo cáo', 'Report', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111706', '111700', 3, 'Y', 'O', 'BA0003', 'BA', 'ISSUES', 'Khai báo đợt phát hành trái phiếu', 'Create bond issuance code', 'YYYYYYYNNYY', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111707', '111700', 3, 'Y', 'A', 'BAIMP', 'BA', 'SEIMPORTFILE', 'Import dữ liệu giá bond', 'Import bond price data', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111708', '111700', 3, 'Y', 'O', 'BA9000', 'BA', 'SBREFMRKDATA', 'Giá thị trường của tài sản', 'Management of market price', 'NYYYYYYNNYY', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111709', '111700', 3, 'Y', 'O', 'BA9000', 'BA', 'EMAILBONDAGENT', 'Quản lý danh sách Email Bond agent', 'Management of Email Bond agent', 'YYYYYYYNNYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111710', '111700', 2, 'Y', 'O', 'BA0001', 'BA', 'TASKBONDAGENT', 'Nhắc việc cho Bond Agent', 'Bond Agent Task', 'YYYYYYYNNYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111711', '111700', 3, 'Y', 'O', NULL, 'BA', 'ISSUESHIST', 'Quản lý đợt phát hành trái phiếu (lịch sử)', 'Bond issue management (history)', 'YYYYYYYNNYY', NULL);COMMIT;