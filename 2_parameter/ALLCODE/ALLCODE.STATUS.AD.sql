SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('STATUS','NULL') AND NVL(CDTYPE,'NULL') = NVL('AD','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('AD', 'STATUS', 'P', 'Chờ duyệt', 0, 'Y', 'Approval pending');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('AD', 'STATUS', 'R', 'Hủy', 0, 'Y', 'Cancel');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('AD', 'STATUS', 'A', 'Hoàn thành', 1, 'Y', 'Finish');COMMIT;