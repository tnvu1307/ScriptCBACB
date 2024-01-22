SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260177;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260177, 'Tài khoản có cờ "Thu ngay citad"=YES, vui lòng thực hiện giao dịch ở 6639
1/ Tiếp tục thực hiện 6621 -> "OK"
2/ Hủy bỏ 6621: "CANCEL"', 'The account has the flag "Collect citad immediately"=YES, please make the transaction at 6639
1/ Continue executing 6621 -> "OK"
2/ Cancel 6621: "CANCEL"', 'CF', NULL);COMMIT;