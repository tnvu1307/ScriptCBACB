SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -700085;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-700085, '[-700085]: Chỉ có thể xác nhận các lệnh chưa xác nhận!', '[-700085]: The order has been confirmed before!', 'OD', NULL);COMMIT;