SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('INRATE','NULL') AND NVL(CDTYPE,'NULL') = NVL('DD','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('DD', 'INRATE', 'SHV', 'SHV', 0, 'Y', 'SHV');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('DD', 'INRATE', 'SBV', 'SBV', 1, 'Y', 'SBV');COMMIT;