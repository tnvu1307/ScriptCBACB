SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('AFGRPSTATUS','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'AFGRPSTATUS', 'A', 'Hoạt động', 1, 'Y', 'Active');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'AFGRPSTATUS', 'E', 'Ngưng hoạt động', 2, 'Y', 'Expire ');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'AFGRPSTATUS', 'P', 'Chờ duyệt', 3, 'Y', 'Pending');COMMIT;