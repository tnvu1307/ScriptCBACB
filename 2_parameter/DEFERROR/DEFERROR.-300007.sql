SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -300007;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-300007, '[-300007]: Không thể thực hiện do còn tài khoản có CK cầm cố', '[-300007]: Unachievable by even the pledged securities account', 'CA', NULL);COMMIT;