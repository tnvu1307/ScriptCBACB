SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('UNHOLD','NULL') AND NVL(CDTYPE,'NULL') = NVL('MT','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('MT', 'UNHOLD', 'N', 'Không', 0, 'Y', 'No');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('MT', 'UNHOLD', 'Y', 'Có', 0, 'Y', 'Yes');COMMIT;