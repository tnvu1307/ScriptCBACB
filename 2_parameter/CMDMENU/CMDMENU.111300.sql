SET DEFINE OFF;DELETE FROM CMDMENU WHERE 1 = 1 AND NVL(PRID,'NULL') = NVL('111300','NULL');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111301', '111300', 3, 'Y', 'O', 'OD0003', 'OD', 'ODMAST', 'Sổ lệnh', 'Orders book', 'NYNNYYYNNYN', '');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111302', '111300', 3, 'Y', 'O', 'OD0003', 'OD', 'ODMASTIMPORT', 'Tổng hợp nguồn lệnh client và broker', 'Order source from client and broker', 'NNNNYYYNNYN', '');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111303', '111300', 3, 'Y', 'A', 'OD0005', 'OD', 'ETFWSAP', 'Màn hình nhập kết quả giao dịch hoán đổi ETF', 'Enter ETF swap result', 'YYYYYYYYYYY', '8894');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111304', '111300', 3, 'N', 'T', 'OD0006', 'OD', '', 'Giao dịch', 'Transaction', 'YYYYYYYYYYN', '');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111305', '111300', 3, 'Y', 'A', 'OD0007', 'OD', 'ODMASTCOMPARE', 'Màn hình đối chiếu kết quả giao dịch', 'Transaction reconciliation', 'YYYYYYYYYYY', '');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111309', '111300', 3, 'Y', 'R', 'OD0022', 'OD', 'RPTMASTER', 'Báo cáo', 'Report', 'YYYYYYYYYYN', '');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111310', '111300', 3, 'Y', 'A', 'OD0023', 'OD', 'ODGENERALVIEW', 'Tra cứu tổng hợp', 'General view', 'NYNNYYYYYYN', '');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111313', '111300', 3, 'Y', 'A', 'OD0019  ', 'OD', 'BROKERCONFIRM', 'Xác nhận số dư giao dịch', 'Broker confirm', 'YYYYYYYYYYN', '1130,1111,3394');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111329', '111300', 3, 'Y', 'A', 'ODIMP', 'OD', 'ODIMPORTFILE', 'Import giao dịch theo file', 'Synchronous data from file', 'YYYYYYYYYYN', '');Insert into CMDMENU   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD) Values   ('111330', '111300', 3, 'Y', 'O', 'OD0003', 'OD', 'UNHOLDSEMAST', 'Unhold chứng khoán trong ngày', 'Unhold securities', 'NNNNYYYNNYN', '');COMMIT;