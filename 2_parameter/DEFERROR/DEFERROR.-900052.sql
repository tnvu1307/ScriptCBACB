SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -900052;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-900052, '[-900052]: Đã xác nhận 2296 nên không thể xóa !', '[-900052]: EXECUTED 2296 CANNOT DELETE !', 'SE', NULL);COMMIT;