SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('PRINFRQCD','NULL') AND NVL(CDTYPE,'NULL') = NVL('LN','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'PRINFRQCD', 'Y', 'Năm', 0, 'Y', 'Year');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'PRINFRQCD', 'H', 'Nửa năm', 1, 'Y', 'Half of year');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'PRINFRQCD', 'Q', 'Quý', 2, 'Y', 'Quarter');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'PRINFRQCD', 'M', 'Tháng', 3, 'Y', 'Month');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'PRINFRQCD', 'L', 'Cuối kỳ', 4, 'Y', 'End of term');COMMIT;