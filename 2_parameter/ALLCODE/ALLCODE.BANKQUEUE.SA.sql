SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('BANKQUEUE','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'BANKQUEUE', '001', 'VCB', 0, 'Y', 'VCB');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'BANKQUEUE', '002', 'BIDV', 1, 'Y', 'BIDV');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'BANKQUEUE', '003', 'ACB', 2, 'Y', 'ACB');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'BANKQUEUE', '004', 'VIB', 3, 'Y', 'VIB');COMMIT;