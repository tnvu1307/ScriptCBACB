SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100149;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100149, '[-100149]: TK nhận là nhân viên công ty!', '[-100149]: Receive sub account is PHS staff account!', 'CF', NULL);COMMIT;