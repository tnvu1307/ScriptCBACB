SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260173;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260173, '[-260173]: Số tiền phong toả vẫn còn !', '[-260173]: Hold balance is still !', 'SA', NULL);COMMIT;