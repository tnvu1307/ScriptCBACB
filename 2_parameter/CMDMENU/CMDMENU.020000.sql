SET DEFINE OFF;

DELETE FROM CMDMENU WHERE 1 = 1 AND NVL(PRID,'NULL') = NVL('020000','NULL');

Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020002', '020000', 3, 'Y', 'A', 'SY2002', 'SA', 'CALENDAR', 'Lịch làm việc', 'Calendar management', 'YYYYYYYYYYN', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020004', '020000', 3, 'Y', 'O', 'SY2004', 'SA', 'ISSUERS', 'Tổ chức phát hành', 'Issuers management', 'YYYYYYYNNYY', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020005', '020000', 3, 'Y', 'O', 'SY2005', 'SA', 'DEPOSIT_MEMBER', 'Thành viên lưu ký', 'Deposit member management', 'YYYYYYYNNYN', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020007', '020000', 3, 'Y', 'O', 'SY2007', 'SA', 'FEEMASTER', 'Bảng phí giao dịch', 'Fee management', 'YYYYYYYNNYN', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020008', '020000', 3, 'Y', 'O', 'SY2007', 'SA', 'CIFEEDEF', 'Bảng phí trả sở & VSD', 'Fee paid VSD, HSX, HNX, UPCOM', 'YYYYYYYNNYN', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020010', '020000', 3, 'Y', 'A', 'SY3007', 'SA', 'SECURITIES_INFO', 'Thông tin chứng khoán', 'Stocks information', 'YYYYYYYYYYN', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020011', '020000', 3, 'Y', 'O', 'SY2011', 'SA', 'CRBBANKLIST', 'Danh sách mã CITAD của ngân hàng', 'CITAD Bank code listing', 'YYYYYYYNNYY', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020017', '020000', 3, 'Y', 'A', 'SY2017', 'SA', 'READFILE', 'Đồng bộ dữ liệu từ File', 'Synchronous data from file', 'YYYYYYYYYYN', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020018', '020000', 3, 'Y', 'A', 'SY2016', 'SA', 'APRREADFILE', 'Duyệt đồng bộ dữ liệu từ File', 'Approve synchronous data from file', 'YYYYYYYYYYN', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020019', '020000', 3, 'Y', 'O', 'SY1010', 'SA', 'SYSVAR', 'Tham số hệ thống', 'Change sysvar value', 'NYYNYYNNNNY', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020021', '020000', 3, 'Y', 'O', 'SY2022', 'SA', 'BANKNOSTRO', 'Khai báo các tài khoản đi tiền/nhận tiền theo nghiệp vụ', 'Declare accounts Inward/Outward money by task', 'YYYYYYYNNYN', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020024', '020000', 3, 'Y', 'A', 'SY2024', 'SA', 'IMPORTFILE', 'Import giao dịch theo file', 'Synchronous data from file', 'YYYYYYYYYYN', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020025', '020000', 3, 'Y', 'A', 'SY2025', 'SA', 'APRIMPORTFILE', 'Duyệt Import giao dịch theo file', 'Approve Synchronous data from file', 'YYYYYYYYYYN', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020027', '020000', 3, 'Y', 'A', 'SY2027', 'SA', 'SENTSMS', 'Gửi SMS theo danh sách', 'Sent SMS for template', 'YYYYYYYYYYN', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020119', '020000', 3, 'Y', 'A', 'SY2015', 'SA', 'READFILECV', 'Chuyển đổi dữ liệu từ File', 'Convert data from file', 'YYYYYYYYYYN', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020200', '020000', 3, 'Y', 'O', 'SY1010', 'SA', 'FILEUPLOADDOCTYPE', 'Tham số quản lý file', 'Change Management of the file value', 'NYYNYYNNNNY', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020300', '020000', 3, 'Y', 'A', NULL, 'SA', 'SYN_TO_FIIN', 'Đồng bộ dữ liệu về FIIN', 'Sync data on FIIN', 'NNNNNNNNNNN', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020400', '020000', 3, 'Y', 'A', NULL, 'SA', 'SYNFIIN', 'Đồng bộ dữ liệu từ FIIN vào CB', 'Sync data from FIIN to CB', 'NNNNNNNNNNN', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020401', '020000', 3, 'Y', 'O', NULL, 'SA', 'MANUALCAL', 'Quản lý xử lý thủ công', 'Manual handling management', 'NYYNYYNNNNY', NULL);
Insert into CMDMENU
   (CMDID, PRID, LEV, LAST, MENUTYPE, MENUCODE, MODCODE, OBJNAME, CMDNAME, EN_CMDNAME, AUTHCODE, TLTXCD)
 Values
   ('020401', '020000', 3, 'Y', 'O', '', 'SA', 'MANUALCAL', 'Quản lý xử lý thủ công', 'Manual handling management', 'NYYNYYNNNNY', NULL);
COMMIT;