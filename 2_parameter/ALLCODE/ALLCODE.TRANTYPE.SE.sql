SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('TRANTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('SE','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SE', 'TRANTYPE', 'C', 'Tăng', 1, 'Y', 'Credit');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SE', 'TRANTYPE', 'D', 'Giảm', 2, 'Y', 'Debit');COMMIT;