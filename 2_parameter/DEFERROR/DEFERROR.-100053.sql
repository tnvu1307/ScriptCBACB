SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100053;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100053, '[-100053]: Thanh toán vượt quá hạn mức cho phép!', '[-100053]: Cash limit is exceeded!', 'SA', NULL);COMMIT;