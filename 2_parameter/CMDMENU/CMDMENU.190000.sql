SET DEFINE OFF;DELETE FROM CMDMENU WHERE 1 = 1 AND NVL(PRID,'NULL') = NVL('190000','NULL');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('190001', '190000', 3, 'Y', 'O', NULL, 'SA', 'MARKET_INFO', 'Thống kê thị trường hàng ngày theo chỉ số', 'Statistics of market  by index daily', 'YYYYYYYNNYY', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('190002', '190000', 3, 'Y', 'O', NULL, 'SA', 'INDEX_INFO', 'Quản lý thông tin chỉ số thị trường', 'Management of Index information', 'YYYYYYYNNYY', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('190003', '190000', 3, 'Y', 'O', NULL, 'SA', 'NAV_INFO', 'Quản lý kết quả NAV đồng bộ từ FA', 'Management of  NAV sync from FA', 'YYYYYYYNNYY', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('190004', '190000', 3, 'Y', 'O', NULL, 'SA', 'SYN_AITHER_REQ', 'Tra cứu lịch sử đồng bộ dữ liệu vận hành qua DNA', 'History of operation data sync to DNA (without customer)', 'NYNNYYNNNNY', NULL);COMMIT;