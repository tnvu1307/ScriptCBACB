SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('BANKPAIDMETHOD','NULL') AND NVL(CDTYPE,'NULL') = NVL('LN','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'BANKPAIDMETHOD', 'I', 'Trả lãi NH ngay khi thu KH', 0, 'Y', 'Pay int. when collect');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'BANKPAIDMETHOD', 'A', 'Trả lãi NH khi KH tất toán', 1, 'Y', 'interest payment when settling');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'BANKPAIDMETHOD', 'P', 'Trả lãi NH khi KH trả gốc', 2, 'Y', 'Pay int. along with princ.');COMMIT;