SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260015;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260015, '[-260015]: Giao dịch giải ngân phải được xóa trước khi xóa HĐ vay !', '[-260015]: Drawdown transaction is deleted before deleting Credit contract!', 'DF', NULL);COMMIT;