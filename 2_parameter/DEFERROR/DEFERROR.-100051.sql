SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100051;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100051, '[-100051]: Giao dịch vượt quá hạn mức cho phép!', '[-100051]: Transaction limit is exceeded!', 'SA', NULL);COMMIT;