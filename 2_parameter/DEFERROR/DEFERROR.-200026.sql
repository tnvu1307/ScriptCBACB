SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200026;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200026, '[-200026]: ERR_CF_AFMAST_DEPORATE_OVER_AFTYPE!', '[-200026]: ERR_CF_AFMAST_DEPORATE_OVER_AFTYPE!', 'CF', NULL);COMMIT;