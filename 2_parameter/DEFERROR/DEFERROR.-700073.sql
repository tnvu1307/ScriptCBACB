SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -700073;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-700073, '[-700073]: Chứng khoán này chỉ được đặt trong phiên đóng cửa', '[-700073]: This symbol order only in Pre_Close session', 'OD', NULL);COMMIT;