SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100993;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100993, 'Không được phân quyền mức tiểu khoản của khách hàng để sử dụng sản phẩm', 'Cannot assign on sub account level to use produat type!', 'SA', NULL);COMMIT;