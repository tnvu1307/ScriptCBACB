SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('MONTHDAY','NULL') AND NVL(CDTYPE,'NULL') = NVL('IC','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'MONTHDAY', 'A', 'Thực tế', 0, 'Y', 'Actual');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'MONTHDAY', 'M', 'Hằng tháng', 1, 'Y', 'Monthly');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('IC', 'MONTHDAY', 'E', 'Tháng kiểu Euro', 2, 'Y', 'Month (Europe type)');COMMIT;