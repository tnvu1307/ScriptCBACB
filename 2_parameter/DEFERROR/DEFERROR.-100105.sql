SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100105;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100105, '[-100105]: ERR_SA_CERATE_NOT_IN_SYSTEM_RATE_RANGE!', '[-100105]: ERR_SA_CERATE_NOT_IN_SYSTEM_RATE_RANGE!', 'SA', NULL);COMMIT;