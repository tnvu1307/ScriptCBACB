SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -180015;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-180015, '[-180015]: Giá vay margin tầng hệ thống thấp hơn tầng loại hình!', '[-180015]:System margin price rate is lower than defined margin price rate of type !', 'MR', NULL);COMMIT;