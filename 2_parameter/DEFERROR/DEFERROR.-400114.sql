SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400114;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400114, '[-400114]:Trạng thái corebank của tiểu khoản không hợp lệ!', '[-400114]:Corebank status invalid!', 'CI', NULL);COMMIT;