SET DEFINE OFF;DELETE FROM CMDMENU WHERE 1 = 1 AND NVL(PRID,'NULL') = NVL('111600','NULL');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111601', '111600', 3, 'N', 'P', NULL, NULL, NULL, 'Quản trị', 'Administration', 'YYYYYYYNNYY', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111603', '111600', 3, 'N', 'T', 'DD0003', 'DD', NULL, 'Giao dịch', 'Transaction', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111604', '111600', 3, 'Y', 'R', 'CI0004', 'DD', 'RPTMASTER', 'Báo cáo', 'Report', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111605', '111600', 3, 'Y', 'A', 'DD0005', 'DD', 'SEGENERALVIEW', 'Tra cứu tổng hợp', 'General view', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111606', '111600', 3, 'Y', 'A', 'DDIMP', 'DD', 'DDIMPORTFILE', 'Import giao dịch theo file', 'Synchronous data from file', 'YYYYYYYYYYN', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111608', '111600', 3, 'Y', 'A', 'DD2016', 'DD', 'DDAPRREADFILE', 'Duyệt đồng bộ dữ liệu từ file', 'Approve synchronous data from file', 'YYYYYYYYYY', NULL);Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111609', '111600', 3, 'Y', 'O', 'DD0009', 'DD', 'TBL_SHV_FEE_COLLECTION', 'Lịch sử thu phí', 'Fee collection history', 'NYYNYYYNNYN', NULL);COMMIT;