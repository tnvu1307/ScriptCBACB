SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100815;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100815, '[-100815]: số ngày cho mỗi gia hạn không được phép vượt quá tổng chu kì món vay!', '[-100815]: Extension days can not exceed total period of loan', NULL, NULL);COMMIT;