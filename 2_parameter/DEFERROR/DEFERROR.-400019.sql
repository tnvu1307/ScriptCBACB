SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400019;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400019, '[-400019]: Mã loại hình tiền gửi không tồn tại!', '[-400019]:Product type not exist!', 'CI', NULL);COMMIT;