SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100040;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100040, '[-100040]: Mã chi nhánh không tồn tại!', '[-100040]: Branch code not exist!', 'SA', NULL);COMMIT;