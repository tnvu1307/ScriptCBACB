SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('DEFPRODUCT','NULL') AND NVL(CDTYPE,'NULL') = NVL('SY','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'DEFPRODUCT', 'AF', 'Loại hình giao dịch', 0, 'Y', 'Contract type');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'DEFPRODUCT', 'CI', 'Loại hình tiền gửi', 1, 'Y', 'Saving type');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'DEFPRODUCT', 'SE', 'Loại hình CK', 2, 'Y', 'Security type');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'DEFPRODUCT', 'OD', 'Loại hình lệnh', 3, 'Y', 'Order type');COMMIT;