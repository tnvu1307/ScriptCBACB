SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('DATATYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DATATYPE', 'C', 'Ký tự', 0, 'Y', 'Character');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DATATYPE', 'D', 'Ngày', 1, 'Y', 'Day');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'DATATYPE', 'N', 'Số', 2, 'Y', 'Number');COMMIT;