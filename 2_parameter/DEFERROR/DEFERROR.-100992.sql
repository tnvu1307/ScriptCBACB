SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100992;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100992, 'Không được phân quyền mức phòng giao dịch để sử dụng sản phẩm', 'Cannot assign on trading office level to use produat type!', 'SA', NULL);COMMIT;