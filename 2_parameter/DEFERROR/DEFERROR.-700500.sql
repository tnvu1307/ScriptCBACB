SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -700500;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-700500, '[-700500]: Dữ liệu bị trùng. Đề nghị duyệt trước khi thêm mới!', '[-700500]: Data duplicate. Please approve before making new one!', 'SA', NULL);COMMIT;