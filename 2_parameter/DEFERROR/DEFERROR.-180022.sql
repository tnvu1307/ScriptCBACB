SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -180022;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-180022, '[-180022]: Trạng thái hợp đồng không hợp lệ!', '[-180022]: Contract status is  invalid!', 'EA', NULL);COMMIT;