SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ODFEETYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('RE','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RE', 'ODFEETYPE', 'M', 'Phí thực thu', 1, 'Y', 'Actual fee receive');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RE', 'ODFEETYPE', 'F', 'Phí cố định', 2, 'Y', 'Fixed fee');COMMIT;