SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400214;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400214, '[-400214]: Giao dịch không được xóa vì đã gom bảng kê sang ngân hàng!', '[-400214]: Transaction can not be deleted. Lists already sent to bank!', 'CI', NULL);COMMIT;