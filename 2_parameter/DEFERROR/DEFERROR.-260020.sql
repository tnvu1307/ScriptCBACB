SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260020;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260020, '[-260020] Số tiền rút không đủ', '[-260020] Not enough withdrawal amount', 'DF', NULL);COMMIT;