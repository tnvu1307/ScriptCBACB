SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200091;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200091, '[-200091]:User không tồn tại hoặc user ở trạng thái chưa áp dụng !', '[-200091]: User not exist or not active!', 'CF', NULL);COMMIT;