SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100070;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100070, '[-100070]: Chưa định nghĩa hạn mức nhập giao dịch!', '[-100070]: Transaction limit is not defined!', 'SA', NULL);COMMIT;