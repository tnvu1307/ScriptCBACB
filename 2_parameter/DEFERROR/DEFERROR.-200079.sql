SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200079;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200079, '[-200079]: ERR_CF_T0_USER_LIMIT_GREATER_ZERO', '[-200079]: ERR_CF_T0_USER_LIMIT_GREATER_ZERO', 'CF', NULL);COMMIT;