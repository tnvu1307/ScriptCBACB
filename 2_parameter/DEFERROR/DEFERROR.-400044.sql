SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400044;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400044, '[-400044]: Overdraft interest accure must be equal zero!', '[-400044]: Overdraft interest accure must be equal zero!', 'CI', NULL);COMMIT;