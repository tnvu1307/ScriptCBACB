SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -670059;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-670059, '[-670059]: Giao dịch bị huỷ', '[-670059]: Transaction canceled', 'RM', 0);COMMIT;