SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ORATEOPCD','NULL') AND NVL(CDTYPE,'NULL') = NVL('LN','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'ORATEOPCD', '+', 'Plus', 0, 'Y', 'Plus');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'ORATEOPCD', '%', 'Percentage', 1, 'Y', 'Percentage');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('LN', 'ORATEOPCD', '-', 'Minus', 1, 'Y', 'Minus');COMMIT;