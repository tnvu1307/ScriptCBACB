SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('DEDUCTEDPLACE','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DEDUCTEDPLACE', 'SHV', 'Tại SHV', 1, 'Y', 'At SHV');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DEDUCTEDPLACE', 'CTCK', 'Tại công ty chứng khoán', 2, 'Y', 'At a securities company');COMMIT;