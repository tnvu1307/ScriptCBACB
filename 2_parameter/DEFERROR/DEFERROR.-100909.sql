SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100909;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100909, '[-100909]: Số tự tăng đã tồn tại!', '[-100909]: AutoID already exists!', 'SA', 0);COMMIT;