SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -930110;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-930110, '[-930110]: Ngày hiệu lực phải là ngày làm việc', '[-930110]: Value date must be working day', 'AP', NULL);COMMIT;