SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400048;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400048, '[-400048]: Tiểu khoản có tồn tại nợ trả chậm chưa thanh toán mới được phép thực hiện giao dịch này!', '[-400048]: Transaction can only process within account remain deferred outstanding', 'CI', NULL);COMMIT;