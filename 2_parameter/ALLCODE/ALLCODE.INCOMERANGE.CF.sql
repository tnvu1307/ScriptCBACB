SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('INCOMERANGE','NULL') AND NVL(CDTYPE,'NULL') = NVL('CF','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'INCOMERANGE', '000', 'Khác', 0, 'Y', 'Other');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'INCOMERANGE', '001', '< 100 triệu/năm', 1, 'Y', '< 100 million/year');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'INCOMERANGE', '002', '100-200 triệu/năm', 2, 'Y', '100-200 million/year');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'INCOMERANGE', '003', '200-500 triệu/năm', 3, 'Y', '200-500 million/year');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'INCOMERANGE', '004', '500 triệu - 1 tỷ/năm', 4, 'Y', '500 million - 1billion/year');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'INCOMERANGE', '005', '> 1 tỷ/năm', 5, 'Y', '> 1 billion/year');COMMIT;