SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -180021;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-180021, '[-180021]: Trùng số hợp đồng!', '[-180021]: Duplicate contract number!', 'EA', NULL);COMMIT;