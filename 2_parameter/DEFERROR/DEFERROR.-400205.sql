SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400205;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400205, '[-400205]: Tài khoản vẫn còn tiền phong tỏa !', '[-400205]: Blocked amount still exist', 'CI', NULL);COMMIT;