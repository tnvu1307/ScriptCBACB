SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -570007;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-570007, 'Số dư bảo đảm không đủ', 'Mortgage amount not enough', 'TD', NULL);COMMIT;