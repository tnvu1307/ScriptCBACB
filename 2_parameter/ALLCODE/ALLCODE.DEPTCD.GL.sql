SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('DEPTCD','NULL') AND NVL(CDTYPE,'NULL') = NVL('GL','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('GL', 'DEPTCD', '1', 'Phòng giao dịch', 0, 'Y', 'Trading department');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('GL', 'DEPTCD', '2', 'Phòng kế toán', 1, 'Y', 'Accounting department');COMMIT;