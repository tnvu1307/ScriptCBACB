SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100405;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100405, '[-100405]: Loại hình DF đã được gán vào rổ!', '[-100405]: DF type is assigned already!', 'SA', NULL);COMMIT;