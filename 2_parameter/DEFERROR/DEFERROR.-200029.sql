SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200029;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200029, '[-200029]: ERR_CF_OVER_TRADELIMIT!', '[-200029]: ERR_CF_OVER_TRADELIMIT!', 'CF', NULL);COMMIT;