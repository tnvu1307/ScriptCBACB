SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -560004;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-560004, 'Trạng thái tài khoản không hợp lệ', 'The status of remiser account is invalid', 'RE', NULL);COMMIT;