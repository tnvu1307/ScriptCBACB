SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100146;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100146, '[-100146]:Thông tin khách hàng thay đổi đã được duyệt!', '[-100146]: Customer ifo changed approve!', 'CF', NULL);COMMIT;