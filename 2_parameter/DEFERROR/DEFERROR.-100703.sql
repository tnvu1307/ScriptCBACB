SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100703;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100703, '[-100703]: Chua thu het han muc T0', '[-100703]: ERR_SA_T0_LIMIT_STILL_REMAIN', 'SA', NULL);COMMIT;