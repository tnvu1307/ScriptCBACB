SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('TDSRC','NULL') AND NVL(CDTYPE,'NULL') = NVL('TD','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('TD', 'TDSRC', 'C', 'Công ty', 0, 'Y', 'Company');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('TD', 'TDSRC', 'B', 'Ngân hàng', 1, 'Y', 'Bank');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('TD', 'TDSRC', 'O', 'Khác', 2, 'Y', 'Other');COMMIT;