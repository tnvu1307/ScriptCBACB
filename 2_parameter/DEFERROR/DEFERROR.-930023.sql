SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -930023;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-930023, '[-930023]: File import trùng với dữ liệu hệ thống!', '[-930023]: The import file duplicate to the system data!', 'SA', NULL);COMMIT;