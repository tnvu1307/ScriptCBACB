SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('CRTRANT','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'CRTRANT', '001', 'Nhập quỹ đầu ngày', 0, 'Y', 'Import fund begin of day');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'CRTRANT', '003', 'Phí chuyển nhượng OTC', 2, 'Y', 'OTC transfer fee');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'CRTRANT', '004', 'Nộp tiền Thuế OTC', 3, 'Y', 'Deposit OTC Tax ');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'CRTRANT', '005', 'Nộp tiền đấu giá IPO', 4, 'Y', 'Deposit IPO');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'CRTRANT', '007', 'Phí quản lý cổ đông (Đổi sổ, thay đổi thông tin)', 6, 'Y', 'Management fee (change book/information)');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'CRTRANT', '009', 'KH nộp tiền mua PHT', 8, 'Y', 'Proessional customer');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'CRTRANT', '013', 'Thu phí chuyển nhượng CP không thông sàn', 12, 'Y', 'Collect OTC transfer fee');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'CRTRANT', '014', 'Phí VSD thu chuyển nhượng CP không thông sàn', 13, 'Y', 'OTC transfer fee');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'CRTRANT', '021', 'Tiền KH nộp thừa', 14, 'Y', 'Overpaid ');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'CRTRANT', '024', 'Nộp tiền phong tỏa, giải tỏa, cầm cố CK', 16, 'Y', 'Deposit block/release/mortgage');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'CRTRANT', '023', 'Thuế chuyển nhượng CP không thông sàn', 16, 'Y', 'Collect OTC transfer tax');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'CRTRANT', '050', 'Khác', 19, 'Y', 'Other');COMMIT;