SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400049;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400049, '[-400049]:Số khoản thụ hưởng chưa đăng ký!', '[-400049]:Benificiary account not registered!', 'SA', NULL);COMMIT;