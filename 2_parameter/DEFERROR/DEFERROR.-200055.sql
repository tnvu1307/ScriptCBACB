SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200055;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200055, '[-200055]: ERR_CF_CANNOT_ACTIVE', '[-200055]: ERR_CF_CANNOT_ACTIVE', 'CF', NULL);COMMIT;