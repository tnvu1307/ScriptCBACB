SET DEFINE OFF;DELETE FROM ALLCODE WHERE 1 = 1 AND NVL(CDNAME,'NULL') = NVL('VSTP_SETTLE_STATUS','NULL') AND NVL(CDTYPE,'NULL') = NVL('SA','NULL');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '0', 'Chờ xử lý', 1, 'Y', 'Pending');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '1', 'Ðang Unhold', 2, 'Y', 'Wait to Unhold');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '1.1', 'Ðã Unhold', 3, 'Y', 'Unhold');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '1.2', 'Lỗi Unhold', 4, 'Y', 'Unhold Error');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '2', 'Ðang thanh toán(1)', 5, 'Y', 'Payment in progress(1)');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '2.1', 'Thanh toán thành công(1)', 6, 'Y', 'Successfully payment(1)');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '2.2', 'Ðang thanh toán(2)', 7, 'Y', 'Payment in progress(2)');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '2.3', 'Thanh toán thành công(2)', 8, 'Y', 'Successfully payment(2)');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '2.9', 'Lỗi thanh toán', 9, 'Y', 'Payment error');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '3', 'Ðang Hold', 10, 'Y', 'Wait to Hold');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '3.1', 'Chờ nộp/rút tiền 2201/2202', 11, 'Y', 'Waiting for deposit/withdrawal 2201/2202');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '3.2', 'Lỗi Hold', 12, 'Y', 'Hold Error');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '4', 'Đã gửi và chờ phản hồi', 13, 'Y', 'Sent and awaiting response');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '4.1', 'Hoàn tất', 14, 'Y', 'Completed');Insert into ALLCODE   (CDTYPE, CDNAME, CDVAL, CDCONTENT, LSTODR, CDUSER, EN_CDCONTENT) Values   ('SA', 'VSTP_SETTLE_STATUS', '4.9', 'Từ chối', 15, 'Y', 'Reject');COMMIT;