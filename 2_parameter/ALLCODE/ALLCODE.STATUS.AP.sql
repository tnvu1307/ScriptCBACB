SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('STATUS','NULL') AND NVL(CDTYPE,'NULL') = NVL('AP','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('AP', 'STATUS', 'P', 'Chờ duyệt', 0, 'Y', 'Approval pending');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('AP', 'STATUS', 'A', 'Hoạt động', 1, 'Y', 'Active');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('AP', 'STATUS', 'C', 'Đóng', 3, 'Y', 'Close');COMMIT;