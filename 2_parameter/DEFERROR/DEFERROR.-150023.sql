SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -150023;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-150023, '[-150023]: Yêu cầu không hợp lệ!', '[-150023]: Invalid request!', 'ST', NULL);COMMIT;