SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -670042;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-670042, '[-670042]: Số dư giải toả lớn hơn số dư phong toả', '[-670042]: Unhold balance greater than hold balance', 'RM', 0);COMMIT;