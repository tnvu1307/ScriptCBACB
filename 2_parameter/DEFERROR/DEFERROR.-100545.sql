SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100545;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100545, '[-100545]: Chứng khoán nhận không hợp lệ !', '[-100545]: Receivable securities invalid !', 'PR', NULL);COMMIT;