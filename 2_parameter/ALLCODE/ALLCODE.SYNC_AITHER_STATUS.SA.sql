SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('SYNC_AITHER_STATUS','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'SYNC_AITHER_STATUS', 'P', 'Chờ gửi', 1, 'Y', 'Pending');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'SYNC_AITHER_STATUS', 'Q', 'Đang gửi', 2, 'Y', 'Sending');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'SYNC_AITHER_STATUS', 'E', 'Lỗi', 3, 'Y', 'Error');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'SYNC_AITHER_STATUS', 'R', 'Từ chối', 4, 'Y', 'Reject');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'SYNC_AITHER_STATUS', 'C', 'Hoàn tất', 5, 'Y', 'Complete');COMMIT;