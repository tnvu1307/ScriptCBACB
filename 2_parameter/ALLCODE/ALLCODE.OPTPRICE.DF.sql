SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('OPTPRICE','NULL') AND NVL(CDTYPE,'NULL') = NVL('DF','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('DF', 'OPTPRICE', 'A', 'Tất cả', 0, 'Y', 'All');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('DF', 'OPTPRICE', 'B', 'Giá tham chiếu', 1, 'Y', 'Reference price');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('DF', 'OPTPRICE', 'D', 'Giá mua', 2, 'Y', 'Buying price');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('DF', 'OPTPRICE', 'O', 'Khác', 2, 'Y', 'Other');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('DF', 'OPTPRICE', 'S', 'Giá sàn', 5, 'Y', 'Floor price');COMMIT;