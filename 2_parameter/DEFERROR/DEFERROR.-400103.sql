SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400103;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400103, '[-400103]: Vượt quá số lãi thấu chi cộng dồn của tài khoản!', '[-400103]:Overdraft interest accure is not enough!', 'CI', NULL);COMMIT;