SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('DRATE','NULL') AND NVL(CDTYPE,'NULL') = NVL('LN','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'DRATE', 'D1', '30 ngày/tháng', 0, 'Y', '30 days/month');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'DRATE', 'D2', 'Số ngày thực tế', 1, 'Y', 'Actual days');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'DRATE', 'Y1', '360 ngày/năm', 2, 'Y', '360 days/year');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'DRATE', 'Y2', 'Số ngày thực tế', 3, 'Y', 'Actual days');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'DRATE', 'Y3', '365 ngày/năm', 4, 'Y', '360 days/year');COMMIT;