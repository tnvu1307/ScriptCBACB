SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('TYPERATE','NULL') AND NVL(CDTYPE,'NULL') = NVL('CB','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CB', 'TYPERATE', '001', 'Không', 0, 'Y', 'None');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CB', 'TYPERATE', '002', 'LTV', 1, 'Y', 'LTV');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CB', 'TYPERATE', '003', 'CCR', 2, 'Y', 'CCR');COMMIT;