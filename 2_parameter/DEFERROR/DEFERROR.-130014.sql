SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -130014;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-130014, '[-130014]: Auto Transfer không được là tài khoản mặc định!', '[-130014]: Auto Transfer cannot be the default account!', 'DD', NULL);COMMIT;