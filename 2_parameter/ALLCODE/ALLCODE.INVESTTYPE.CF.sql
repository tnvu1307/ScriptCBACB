SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('INVESTTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('CF','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'INVESTTYPE', '000', 'Khác', 0, 'Y', 'Other');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'INVESTTYPE', '001', 'Đầu tư giá trị', 1, 'Y', 'Value invest');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'INVESTTYPE', '002', 'Đầu tư dài hạn', 2, 'Y', 'Long term invest');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'INVESTTYPE', '003', 'Đầu tư ngắn hạn', 3, 'Y', 'Short term invest');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CF', 'INVESTTYPE', '004', 'Thu nhập ổn định', 4, 'Y', 'Stable income');COMMIT;