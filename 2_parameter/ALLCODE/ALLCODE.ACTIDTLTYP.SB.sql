SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ACTIDTLTYP','NULL') AND NVL(CDTYPE,'NULL') = NVL('SB','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SB', 'ACTIDTLTYP', 'N', 'New', 0, 'N', 'New');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SB', 'ACTIDTLTYP', 'A', 'Assign', 1, 'N', 'Assign');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SB', 'ACTIDTLTYP', 'C', 'Comment', 2, 'N', 'Comment');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SB', 'ACTIDTLTYP', 'M', 'Change status', 3, 'N', 'Change status');COMMIT;