SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -670037;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-670037, '[-670037]: Tài khoản không giải toả được', '[-670037]: Account cannot unhold', 'RM', 0);COMMIT;