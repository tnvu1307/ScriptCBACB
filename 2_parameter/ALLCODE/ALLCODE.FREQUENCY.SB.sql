SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('FREQUENCY','NULL') AND NVL(CDTYPE,'NULL') = NVL('SB','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SB', 'FREQUENCY', 'AO', 'At occurrence', 1, 'Y', 'At occurrence');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SB', 'FREQUENCY', 'AN', 'Annual  ', 2, 'Y', 'Annual  ');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SB', 'FREQUENCY', 'MO', 'Monthly', 3, 'Y', 'Monthly');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SB', 'FREQUENCY', '2W', '2 weeks', 4, 'Y', '2 weeks');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SB', 'FREQUENCY', '6M', '6 months', 5, 'Y', '6 months');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SB', 'FREQUENCY', 'QU', 'Quarterly', 6, 'Y', 'Quarterly');COMMIT;