SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -540110;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-540110, 'ERR_LN_APPL_OVERLIMIT', 'ERR_LN_APPL_OVERLIMIT', 'LN', NULL);COMMIT;