SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -300052;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-300052, '[-300052]: Giao dịch không thể xóa vì không đủ số dư tiền', '[-300052]: Transaction can not be deleted due to lack of money', 'CA', NULL);COMMIT;