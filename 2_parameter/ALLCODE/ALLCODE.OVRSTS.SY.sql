SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('OVRSTS','NULL') AND NVL(CDTYPE,'NULL') = NVL('SY','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'OVRSTS', '0', 'Đã duyệt', 0, 'Y', 'Approved');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'OVRSTS', '1', 'Cần checker 1 duyệt', 1, 'Y', 'Checker 1 aprroval needed');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SY', 'OVRSTS', '2', 'Cần checker 2 duyệt', 2, 'Y', 'Checker 2 aprroval needed');COMMIT;