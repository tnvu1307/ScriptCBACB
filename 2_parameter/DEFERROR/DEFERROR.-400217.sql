SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400217;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400217, '[-400217]:Vượt quá hạn mức có thể giao dịch của nhóm tiểu khoản!', '[-400217]: Exceed trading limit of group of sub account!', 'CI', NULL);COMMIT;