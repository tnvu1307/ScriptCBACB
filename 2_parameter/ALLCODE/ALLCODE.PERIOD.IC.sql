SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('PERIOD','NULL') AND NVL(CDTYPE,'NULL') = NVL('IC','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'PERIOD', 'D', 'Hằng ngày', 0, 'Y', 'Daily');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'PERIOD', 'M', 'Hằng tháng', 1, 'Y', 'Monthly');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'PERIOD', 'Y', 'Hằng năm', 2, 'Y', 'Yearly');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'PERIOD', 'S', 'Cố định', 3, 'Y', 'Fixed');COMMIT;