SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -911003;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-911003, '[-911003]: Số TKLK bên mua không hợp hệ!', '[-911003]: The buying custodycd does not match!', 'AP', 0);COMMIT;