SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -670060;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-670060, '[-670060]: Không tìm thấy giao dịch', '[-670060]: Transaction not founded', 'RM', 0);COMMIT;