SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -269011;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-269011, '[-269011]:SLCK CA ghi giảm không hợp lệ!', '[-269011]: Decreasing CA QTTY is invalid', 'SE', NULL);COMMIT;