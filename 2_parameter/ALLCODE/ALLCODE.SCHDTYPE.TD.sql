SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('SCHDTYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('TD','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('TD', 'SCHDTYPE', 'F', 'Cố định', 0, 'Y', 'Fixed');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('TD', 'SCHDTYPE', 'T', 'Bậc thang', 1, 'Y', 'Tier');COMMIT;