SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100708;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100708, 'Ngày chứng từ không hợp lệ', 'BACKDATE INVALID', 'SA', NULL);COMMIT;