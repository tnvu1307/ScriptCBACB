SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('DEPGRCD','NULL') AND NVL(CDTYPE,'NULL') = NVL('GL','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('GL', 'DEPGRCD', '000', 'Trụ sở SBS', 1, 'Y', 'SBS Head Office');COMMIT;