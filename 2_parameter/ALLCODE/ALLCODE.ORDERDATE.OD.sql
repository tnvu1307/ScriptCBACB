SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ORDERDATE','NULL') AND NVL(CDTYPE,'NULL') = NVL('OD','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ORDERDATE', '0', 'Ngày T0', 0, 'Y', 'T0');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ORDERDATE', '-1', 'Ngày T-1', 1, 'Y', 'T1');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('OD', 'ORDERDATE', '-2', 'Ngày T-2', 2, 'Y', 'T2');COMMIT;