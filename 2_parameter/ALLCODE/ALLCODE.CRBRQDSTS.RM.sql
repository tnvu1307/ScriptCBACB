SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('CRBRQDSTS','NULL') AND NVL(CDTYPE,'NULL') = NVL('RM','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'CRBRQDSTS', 'N', 'Chờ xử lý', 0, 'Y', 'Process pending');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'CRBRQDSTS', 'W', 'Chờ hoàn thành', 1, 'Y', 'Sending to center pending');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'CRBRQDSTS', 'C', 'Hoàn thành', 2, 'Y', 'Finish');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'CRBRQDSTS', 'F', 'Lỗi, chờ hoàn thành', 3, 'Y', 'Error');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'CRBRQDSTS', 'T', 'Đang xử lý', 4, 'Y', 'In processing');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'CRBRQDSTS', 'E', 'Lỗi', 5, 'Y', 'Error');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('RM', 'CRBRQDSTS', 'H', 'Hủy bỏ', 6, 'Y', 'Reject');COMMIT;