SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400020;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400020, '[-400020]: Mã loại tiền không tồn tại!', '[-400020]:Currency id not exist!', 'CI', NULL);COMMIT;