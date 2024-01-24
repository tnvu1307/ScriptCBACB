SET DEFINE OFF;

DELETE FROM CMDMENU WHERE 1 = 1 AND NVL(PRID,'NULL') = NVL('150000','NULL');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('151000', '150000', 3, 'Y', 'O', 'REQ', 'ST', 'VSDTXREQ', 'Quản lý thông tin chi tiết điện gửi VSD', 'Manage the details of messages sent VSD', 'NYNNYYYNNN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('152000', '150000', 3, 'Y', 'O', 'INFO', 'ST', 'VSDTXINFO', 'Quản lý thông tin chi tiết điện thông báo từ VSD', 'Manage the notification messages from VSD', 'NYNNYYYNNYN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('154000', '150000', 3, 'Y', 'A', 'ST0007', 'ST', 'RMGENERALVIEW', 'Tra cứu tổng hợp', 'General view', 'YYYYYYYYYYN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('154001', '150000', 3, 'N', 'T', '', 'ST', '', 'Giao dịch', 'Transaction', 'YYYYYYYYYYN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('155000', '150000', 3, 'Y', 'R', 'ST0008', 'STV', 'STVREQUEST', 'Ðiện y/c báo cáo từ VSD', 'Request reports to VSD', 'YYYYYYYYYYN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('155001', '150000', 3, 'Y', 'A', 'ST5001', 'ST', 'CSVCOMPARE_CA', 'Xem file CSV (CA)', 'View CSV file (CA)', 'YYYYYYYYYYN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('155002', '150000', 3, 'Y', 'A', 'ST5002', 'ST', 'CSVCOMPARE_DE', 'Xem file CSV (DE)', 'View CSV file (DE)', 'YYYYYYYYYYN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('155004', '150000', 3, 'Y', 'A', 'ST5004', 'ST', 'CSVCOMPAREVSD_ED', 'Đối chiếu File CSV cuối ngày (ED)', 'Đối chiếu File CSV cuối ngày (ED)', 'NYNNYYYNNN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('156100', '150000', 3, 'Y', 'O', 'REQHIST', 'ST', 'VSDTXREQHIST', 'Tra cứu lịch sử thông tin chi tiết điện gửi VSD', 'Manage history of request messages sent to VSD', 'NYNNYYYNNN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('156200', '150000', 3, 'Y', 'O', 'INFOHIST', 'ST', 'VSDTXINFOHIST', 'Tra cứu lịch sử điện thông báo từ VSD', 'Manage history of notification messages from VSD', 'NYNNYYYNNN', '');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('158000', '150000', 3, 'Y', 'A', 'CSVCMP', 'ST', 'CSVCMP', 'Xem file csv', 'View csv file', 'YYYYYYYYYY', '1515,1509');

COMMIT;