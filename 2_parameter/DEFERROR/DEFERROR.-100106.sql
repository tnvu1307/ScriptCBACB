SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100106;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100106, '[-100106]: ERR_SA_ICRATE_NOT_IN_SYSTEM_RATE_RANGE!', '[-100106]: ERR_SA_ICRATE_NOT_IN_SYSTEM_RATE_RANGE!', 'SA', NULL);COMMIT;