SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('STATUS','NULL') AND NVL(CDTYPE,'NULL') = NVL('CL','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CL', 'STATUS', 'P', 'Chờ duyệt', 0, 'Y', 'Approval pending');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CL', 'STATUS', 'A', 'Hoạt động', 1, 'Y', 'Active');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CL', 'STATUS', 'R', 'Hủy bỏ', 2, 'Y', 'Reject');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CL', 'STATUS', 'S', 'Suspend', 3, 'Y', 'Suspend');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CL', 'STATUS', 'C', 'Đóng', 4, 'Y', 'Close');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('CL', 'STATUS', 'B', 'Phong tỏa', 5, 'Y', 'Blocked');COMMIT;