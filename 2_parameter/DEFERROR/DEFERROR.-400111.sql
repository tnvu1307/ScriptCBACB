SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400111;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400111, '[-400111]: Trạng thái corebank của tiểu khoản không hợp lệ!', '[-400111]:Corebank status invalid', 'CI', NULL);COMMIT;