SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100139;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100139, '[-100139]:Khách hàng chưa kích hoạt trạng thái VSD!', '[-100139]: VSD status not activate', 'CF', NULL);COMMIT;