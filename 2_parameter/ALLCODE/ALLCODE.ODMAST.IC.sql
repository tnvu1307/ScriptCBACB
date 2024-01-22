SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ODMAST','NULL') AND NVL(CDTYPE,'NULL') = NVL('IC','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'ODMAST', '001', 'Tỷ lệ ký quỹ lệnh', 0, 'Y', 'Order secure ratio');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'ODMAST', '002', 'Trạng thái lệnh', 1, 'Y', 'Order status');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'ODMAST', '003', 'Giá đặt', 2, 'Y', 'Order price');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'ODMAST', '004', 'Khối lượng', 3, 'Y', 'Volume');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'ODMAST', '005', 'KL chưa khớp', 4, 'Y', 'Unmatched volume');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'ODMAST', '006', 'KL đã khớp', 5, 'Y', 'Matched volume');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'ODMAST', '007', 'STANDQTTY', 6, 'Y', 'STANDQTTY');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'ODMAST', '008', 'KL hủy', 7, 'Y', 'Canceled volume');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'ODMAST', '009', 'KL sửa', 8, 'Y', 'Edit volume');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'ODMAST', '010', 'KL từ chối', 9, 'Y', 'Reject volume');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'ODMAST', '011', 'Giá khớp', 10, 'Y', 'Matching price');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'ODMAST', '012', 'EXQTTY', 11, 'Y', 'EXQTTY');COMMIT;