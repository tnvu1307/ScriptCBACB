SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -670046;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-670046, '[-670046]: Không đúng định dạng ngày', '[-670046]: invalid datetime format', 'RM', 0);COMMIT;