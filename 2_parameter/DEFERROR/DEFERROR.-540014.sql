SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -540014;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-540014, '[-540014]: Tài khoản vay gốc không tồn tại hoặc loại hình không đúng do đã thực hiện chuyển đổi!', '[-540014]: loan account is not found OR loan type has changed!', 'LN', NULL);COMMIT;