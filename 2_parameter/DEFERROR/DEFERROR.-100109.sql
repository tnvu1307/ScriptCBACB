SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100109;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100109, '[-100109]: ERR_SA_GLACCTNO_NOTFOUND!', '[-100109]:ERR_SA_GLACCTNO_NOTFOUND!', 'SA', NULL);COMMIT;