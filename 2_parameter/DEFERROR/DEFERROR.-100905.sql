SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100905;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100905, '[-100905]: Phải xóa từ bậc cao nhất', '[-100905]: Phải xóa từ bậc cao nhất', 'SA', NULL);COMMIT;