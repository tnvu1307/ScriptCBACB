SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -800003;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-800003, '[-800003]: Số hiệu lệnh không đúng!', '[-800003]: gc_INVALID_ORDERID', 'FO', NULL);COMMIT;