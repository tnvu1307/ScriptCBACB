SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('BUSINESSTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('CF','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'BUSINESSTYPE', '009', 'Khác', 0, 'Y', 'Other');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'BUSINESSTYPE', '002', 'Cty cổ phần', 1, 'Y', 'Joint stock company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'BUSINESSTYPE', '003', 'Cty TNHH', 2, 'Y', 'Limited company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'BUSINESSTYPE', '004', 'Cty FDI', 3, 'Y', 'FDI company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'BUSINESSTYPE', '005', 'Ngân hàng', 4, 'Y', 'Bank');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'BUSINESSTYPE', '006', 'Cty chứng khoán', 5, 'Y', 'Securities company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'BUSINESSTYPE', '007', 'Cty bảo hiểm', 6, 'Y', 'Insurance company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'BUSINESSTYPE', '008', 'Quỹ đầu tư', 7, 'Y', 'Investment fund');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'BUSINESSTYPE', '001', 'Cty nhà nước', 8, 'Y', 'National Company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'BUSINESSTYPE', '014', 'CTĐT tài chính', 9, 'Y', 'Financial investment company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'BUSINESSTYPE', '010', 'CTÐT chứng khoán', 9, 'Y', 'Securities investment company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'BUSINESSTYPE', '011', 'CT Quản lý quỹ', 10, 'Y', 'Fund management company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'BUSINESSTYPE', '012', 'CT niêm yết (cả TT NY và Upcom)', 11, 'Y', 'Listed company (both Listed and Upcom)');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'BUSINESSTYPE', '013', 'Quỹ đầu tư', 12, 'Y', 'Investment fund');COMMIT;