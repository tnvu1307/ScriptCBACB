SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400501;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400501, '[-400501]: Lưu ý, tài khoản sẽ bị xuống mức vi phạm tỷ lệ cảnh báo', '[-400501]: Warning, account will break the Calling rate!', 'SE', NULL);COMMIT;