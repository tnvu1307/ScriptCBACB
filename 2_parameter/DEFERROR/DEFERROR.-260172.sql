SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260172;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260172, '[-260172]: Tài khoản còn nợ phí gia hạn!', '[-260172]: Tài khoản còn nợ phí gia hạn!', 'SA', NULL);COMMIT;