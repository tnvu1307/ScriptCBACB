SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('MATCHTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('FO','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FO', 'MATCHTYPE', 'N', 'Bình thường', 0, 'Y', 'Normal');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FO', 'MATCHTYPE', 'P', 'Thỏa thuận', 1, 'Y', 'Put through');COMMIT;