SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260019;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260019, '[-260019]: Khách hàng này đã được gửi email cảnh báo !', '[-260019]: EMAIL SENT  !', 'SE', NULL);COMMIT;