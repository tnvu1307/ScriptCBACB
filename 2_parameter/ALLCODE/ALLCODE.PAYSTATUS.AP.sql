SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('PAYSTATUS','NULL') AND NVL(CDTYPE,'NULL') = NVL('AP','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('AP', 'PAYSTATUS', 'P', NULL, 0, 'Y', NULL);Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('AP', 'PAYSTATUS', 'T', 'Đã chuyển tiền', 1, 'Y', 'Transferred money');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('AP', 'PAYSTATUS', 'R', 'Đã nhận tiền bán', 2, 'Y', 'Received the sale money');COMMIT;