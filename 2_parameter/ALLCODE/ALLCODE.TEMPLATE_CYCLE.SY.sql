SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('TEMPLATE_CYCLE','NULL') AND NVL(CDTYPE,'NULL') = NVL('SY','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'TEMPLATE_CYCLE', 'P', 'Gửi ngay', 1, 'Y', 'Send immediately');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'TEMPLATE_CYCLE', 'I', 'Gửi liên tục', 1, 'Y', 'Continually send');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'TEMPLATE_CYCLE', 'D', 'Hàng ngày', 2, 'Y', 'Daily');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'TEMPLATE_CYCLE', 'W', 'Hàng tuần', 3, 'Y', 'Weekly');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'TEMPLATE_CYCLE', 'M', 'Hàng tháng', 4, 'Y', 'Monthly');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'TEMPLATE_CYCLE', 'Y', 'Hàng năm', 5, 'Y', 'Yearly');COMMIT;