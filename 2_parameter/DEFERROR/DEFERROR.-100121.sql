SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100121;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100121, '[-100121]: Số tài khoản ngân hàng của nghiệp vụ trên đã tồn tại', '[-100121]: The bank account number on the top has already existed', 'SA', 0);COMMIT;