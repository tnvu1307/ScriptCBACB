SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ECONOMIC','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ECONOMIC', '000', 'Mặc định', 0, 'Y', 'Default');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ECONOMIC', '001', 'Bán lẻ dược phẩm và thực phẩm', 1, 'Y', 'Food and medicine retail');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ECONOMIC', '002', 'Bảo hiểm nhân thọ', 2, 'Y', 'Life insurance');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ECONOMIC', '003', 'Bảo hiểm phi nhân thọ', 3, 'Y', 'Term insurance');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ECONOMIC', '004', 'Bất động sản', 4, 'Y', 'Real estate');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ECONOMIC', '005', 'Công nghệ phần mềm và dịch vụ tin học', 5, 'Y', 'Software technology and IT service');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ECONOMIC', '006', 'Các dịch vụ hỗ trợ', 6, 'Y', 'Support service');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ECONOMIC', '007', 'Các nghành công nghiệp chung', 7, 'Y', 'Common Industries');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ECONOMIC', '008', 'Công nghiệp cơ khí/công nghiệp sản xuất máy', 8, 'Y', 'Machinary industry/Producing machine industry');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ECONOMIC', '009', 'Công nghiệp vận tải', 9, 'Y', 'Transportation industry');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ECONOMIC', '010', 'Đại lý bán lẻ', 10, 'Y', 'Retail agency');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'ECONOMIC', '011', 'Dịch vụ tài chính', 11, 'Y', 'Financial service');COMMIT;