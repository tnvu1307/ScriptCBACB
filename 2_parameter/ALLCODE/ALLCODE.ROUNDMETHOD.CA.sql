SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ROUNDMETHOD','NULL') AND NVL(CDTYPE,'NULL') = NVL('CA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CA', 'ROUNDMETHOD', '0', 'Làm tròn chuẩn', 1, 'Y', 'Round');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CA', 'ROUNDMETHOD', '1', 'Làm tròn lên', 2, 'Y', 'Roundup');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CA', 'ROUNDMETHOD', '2', 'Làm tròn xuống', 3, 'Y', 'Rounddown');COMMIT;