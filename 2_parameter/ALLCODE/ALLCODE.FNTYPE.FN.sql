SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('FNTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('FN','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FN', 'FNTYPE', 'TRU', 'Ủy thác', 1, 'Y', 'Trust unit');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FN', 'FNTYPE', 'OPN', 'Quỹ mở', 2, 'Y', 'Open fund');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FN', 'FNTYPE', 'CLS', 'Quỹ đóng', 3, 'Y', 'Closed fund');COMMIT;