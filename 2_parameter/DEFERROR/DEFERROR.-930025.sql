SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -930025;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-930025, '[-930025]: Không được phép xóa với loại phí trên!', '[-930025]: Deletion is not allowed with the above fee!', 'SA', NULL);COMMIT;