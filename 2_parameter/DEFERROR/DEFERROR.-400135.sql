SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400135;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400135, '[-400135]: Số tiền ứng hoặc phí ứng không hợp lệ!', '[-400135]: Amount or fee is invalid!', 'CI', NULL);COMMIT;