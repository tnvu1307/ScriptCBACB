SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -180005;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-180005, '[-180005]: Tỷ lệ cảnh báo phải < Tỷ lệ an toàn!', '[-180005]: Call ratio  < Safe ratio!', 'MR', NULL);COMMIT;