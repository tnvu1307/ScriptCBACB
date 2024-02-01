SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('OTFUNC','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'CASHTRANS', 'Chuyển tiền', 0, 'Y', 'Selling amount transfer');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'STOCKTRANS', 'Chuyển chứng khoán', 1, 'Y', 'Securities selling transfer');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'ADWINPUT', 'Ứng trước tiền bán', 2, 'Y', 'Advance payment');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'ISSUEINPUT', 'Đăng ký quyền mua', 3, 'Y', 'Right issue register');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'MORTGAGE', 'Cầm cố', 4, 'Y', 'Mortgage');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'ORDINPUT', 'Đặt lệnh thông thường', 5, 'Y', 'Normal order');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'COND_ORDER', 'Đặt lệnh điều kiện', 6, 'Y', 'Conditional order');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'GROUP_ORDER', 'Đặt lệnh nhóm', 7, 'Y', 'Group order');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'DEPOSIT', 'Tra cứu giao dịch', 8, 'Y', 'Transactions inquiry');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'SMARTALERT', 'Cảnh báo thông minh', 9, 'Y', 'Smart alert');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'MARKETALERT', 'Cảnh báo thị trường', 10, 'Y', 'Market alert');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'COMPANYALERT', 'Cảnh báo công ty', 11, 'Y', 'Company alert');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'BONDSTOSHARES', 'Chuyển đổi trái phiếu', 12, 'Y', 'Convert bond to stock');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'TERMDEPOSIT', 'Gửi tiết kiệm', 13, 'Y', 'Term deposit');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'ADMINMESSAGES', 'Tao thông điệp cty chứng khoán', 14, 'N', 'Create messages');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'ADMINBRANCH', 'Quản lý ngành', 15, 'N', 'Manage branch');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'OTFUNC', 'AGENTSETTING', 'Quản lý đại lý', 16, 'N', 'Manage representative');COMMIT;