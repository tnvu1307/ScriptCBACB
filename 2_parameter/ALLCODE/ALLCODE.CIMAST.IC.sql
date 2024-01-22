SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('CIMAST','NULL') AND NVL(CDTYPE,'NULL') = NVL('IC','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '001', 'Số dư', 0, 'Y', 'Balance');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '002', 'Ngày không hoạt động', 1, 'Y', 'Inactive day');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '003', 'Trạng thái', 2, 'Y', 'Status');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '004', 'Ngày GD cuối', 3, 'Y', 'Last working day');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '005', 'Số tiền ghi có', 4, 'Y', 'Credit amount');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '006', 'Số tiền ghi nợ', 5, 'Y', 'Debit amount');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '007', 'Lãi TG cộng dồn', 6, 'Y', 'Accrual saving interest');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '008', 'Ngày tính lãi tiền gửi', 7, 'Y', 'Calculating interest day');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '009', 'Lãi thấu chi cộng dồn', 8, 'Y', 'Accrual overdraft interest');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '010', 'Ngày tính lãi thấu chi', 9, 'Y', 'Calculating overdraft interest day');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '011', 'Số dư', 10, 'Y', 'Balance');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '012', 'Phát sinh nợ tháng', 11, 'Y', 'Monthly debit');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '013', 'Phát sinh có tháng', 12, 'Y', 'Monthly credit');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '014', 'AAMT', 13, 'Y', 'AAMT');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '015', 'RAMT', 14, 'Y', 'RAMT');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '016', 'BAMT', 15, 'Y', 'BAMT');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '017', 'EMKAMT', 16, 'Y', 'EMKAMT');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '018', 'MARGINBAL', 17, 'Y', 'MARGINBAL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '019', 'MARGINBAL', 18, 'Y', 'MARGINBAL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'CIMAST', '020', 'ODLIMIT', 19, 'Y', 'ODLIMIT');COMMIT;