SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260158;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260158, '[-260158]: Tài khoản vẫn còn lệnh chưa khớp hết !', '[-260158]: Unmatched order still exist!', 'CF', NULL);COMMIT;