SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100830;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100830, '[-100830]: Mã chứng khoán không có ba kí tự', '[-100830]: SYMBOL DOESN’T HAVE 3 LETTERS', 'DL', NULL);COMMIT;