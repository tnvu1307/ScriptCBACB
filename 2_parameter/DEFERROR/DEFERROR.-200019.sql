SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200019;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200019, '[-200019]: Trùng số lưu ký', '[-200019]: Trading code is duplicated', 'CF', NULL);COMMIT;