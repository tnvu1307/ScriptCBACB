SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -700061;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-700061, '[-700061]: Ứng quá số tiền được phép ứng', '[-700061]: AD amount exceed permitted amount', 'SA', NULL);COMMIT;