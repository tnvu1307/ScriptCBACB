SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260051;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260051, '[-260051]:Loại hình quy định không được dùng tiền làm tài sản đảm bảo!', '[-260051: ACTYPE do not allow to use cash as collateral!', 'DF', NULL);COMMIT;