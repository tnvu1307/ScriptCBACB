SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260160;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260160, '[-260160]: Tài khoản vẫn còn chứng khoán phong tỏa trong các deal DF !', '[-260160]: Blocked stocks of Deals still exist!', 'CF', NULL);COMMIT;