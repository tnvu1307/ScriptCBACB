SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -670081;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-670081, '[-670081]: Tài khoản không đủ tiền', '[-670081]: Balance not enough!', 'RM', 0);COMMIT;