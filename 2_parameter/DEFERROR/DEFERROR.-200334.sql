SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200334;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200334, '[-200334]: Bạn đang thực hiện UTTB cho tài khoản kết nối ngân hàng!', '[-200334]: You are executing AD for corebank account!', 'CF', NULL);COMMIT;