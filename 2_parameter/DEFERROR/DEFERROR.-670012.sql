SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -670012;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-670012, '[-670012]: Bảng kê trùng version', '[-670012]: Duplicate version of Lists', 'RM', 0);COMMIT;