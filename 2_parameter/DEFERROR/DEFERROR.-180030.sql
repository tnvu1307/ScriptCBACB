SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -180030;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-180030, '[-180030]: Hạn mức bảo lãnh T0 của user chưa khai báo', '[-180030]:T0 limit of user is not difined!', 'MR', NULL);COMMIT;