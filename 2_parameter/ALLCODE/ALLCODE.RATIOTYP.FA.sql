SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('RATIOTYP','NULL') AND NVL(CDTYPE,'NULL') = NVL('FA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FA', 'RATIOTYP', 'N', 'NAV', 1, 'Y', 'NAV');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('FA', 'RATIOTYP', 'V', 'Total volume', 2, 'Y', 'Total volume');COMMIT;