SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200030;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200030, '[-200030]: ERR_CF_OVER_ADVANCELINE!', '[-200030]: ERR_CF_OVER_ADVANCELINE!', 'CF', NULL);COMMIT;