SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100997;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100997, '[-100997] Ngân hàng không hợp lệ!', '[-100997] Bank is invalid', 'CF', NULL);COMMIT;