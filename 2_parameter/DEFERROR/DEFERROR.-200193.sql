SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200193;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200193, '[-200193]: Khách hàng này không được phép tạo tiểu khoản Margin!', '[-200193]:Can not create Margin sub account for this customer!', 'CF', NULL);COMMIT;