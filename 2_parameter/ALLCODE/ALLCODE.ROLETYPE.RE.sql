SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('ROLETYPE','NULL') AND NVL(CDTYPE,'NULL') = NVL('RE','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RE', 'ROLETYPE', 'M', 'Môi giới', 0, 'Y', 'Broker');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RE', 'ROLETYPE', 'R', 'Cộng tác viên', 1, 'Y', 'Travelling expense');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RE', 'ROLETYPE', 'T', 'Trưởng phòng', 2, 'Y', 'Team leader');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RE', 'ROLETYPE', 'P', 'Phó giám đốc', 3, 'Y', 'Philippines');COMMIT;