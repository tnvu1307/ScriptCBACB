SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400010;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400010, '[-400010]: Mã loại tiền không tồn tại!', '[-400010]:Currency id not exist!', 'CI', NULL);COMMIT;