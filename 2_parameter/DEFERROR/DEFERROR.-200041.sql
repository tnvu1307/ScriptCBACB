SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200041;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200041, '[-200041]: ERR_CF_OVER_TRADELINE!', '[-200041]: ERR_CF_OVER_TRADELINE!', 'CF', NULL);COMMIT;