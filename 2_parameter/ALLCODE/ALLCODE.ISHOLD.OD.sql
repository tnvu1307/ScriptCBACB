SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ISHOLD','NULL') AND NVL(CDTYPE,'NULL') = NVL('OD','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ISHOLD', 'Y', 'Đã unhold thanh toán', 6, '0', 'Has unhold payment');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ISHOLD', 'N', 'Chưa unhold khi thanh toán', 6, '1', 'Not unhold payment');COMMIT;