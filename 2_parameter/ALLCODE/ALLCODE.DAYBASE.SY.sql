SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('DAYBASE','NULL') AND NVL(CDTYPE,'NULL') = NVL('SY','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'DAYBASE', '360', 'Cơ số ngày', 1, 'Y', 'Day base');COMMIT;