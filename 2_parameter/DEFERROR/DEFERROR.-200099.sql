SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200099;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200099, '[-200099]: Tiểu khoản không được đăng ký giao dịch trực tuyến', '[-200099]: Online trading not registered! ', 'CF', NULL);COMMIT;