SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -540114;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-540114, 'ERR_LN_INTFRQCD_INVALID', 'ERR_LN_INTFRQCD_INVALID', 'LN', NULL);COMMIT;