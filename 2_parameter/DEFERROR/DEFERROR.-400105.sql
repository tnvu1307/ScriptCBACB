SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400105;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400105, '[-400105]: Vượt quá hạn mức giao dịch của tiểu khoản!', '[-400105]:Exceed trading limit', 'CI', NULL);COMMIT;