SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -900109;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-900109, '[-900109]:Tài khoản nhận phải khác tài khoản chuyển đi !', '[-900109]: Transfer and receive account can not be the same!', 'SE', NULL);COMMIT;