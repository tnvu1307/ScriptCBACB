SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100037;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100037, '[-100037]: Mã báo cáo không được trùng!', '[-100037]:Report code is duplicated!', 'SA', NULL);COMMIT;