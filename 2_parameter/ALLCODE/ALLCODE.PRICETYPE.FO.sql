SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('PRICETYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('FO','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FO', 'PRICETYPE', 'AA', 'Tất cả', 0, 'Y', 'All');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FO', 'PRICETYPE', 'LO', 'Giá giới hạn', 0, 'Y', 'Limited price');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FO', 'PRICETYPE', 'MP', 'Giá TT', 1, 'Y', 'Put through price');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FO', 'PRICETYPE', 'ATO', 'ATO', 2, 'Y', 'ATO');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FO', 'PRICETYPE', 'ATC', 'ATC', 3, 'Y', 'ATC');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FO', 'PRICETYPE', 'SL', 'Stop Limit', 5, 'Y', 'Stop Limit');COMMIT;