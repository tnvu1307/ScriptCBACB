SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260156;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260156, '[-260156]: Tài khoản vẫn còn chứng khoán cầm cố VSD !', '[-260156]: Mortgage VSD still exist!', 'SE', NULL);COMMIT;