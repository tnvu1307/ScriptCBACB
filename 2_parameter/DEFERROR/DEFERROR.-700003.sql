SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -700003;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-700003, '[-700003]: ERR_OD_ODTYPE_NOTFOUND', '[-700003]: ERR_OD_ODTYPE_NOTFOUND', 'OD', NULL);COMMIT;