SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -540209;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-540209, 'ERR_LN_LNMAST_NOT_FOUND', 'ERR_LN_LNMAST_NOT_FOUND', 'LN', NULL);COMMIT;