SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -201184;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-201184, '[-201184]: Cần chuyển chứng khoán về một tiểu khoản trước khi bán lô lẻ!', '[-201184]: Need to transfer stock into one sub account before selling odd lot!', 'CF', NULL);COMMIT;