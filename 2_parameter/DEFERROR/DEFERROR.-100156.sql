SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100156;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100156, '[-100156]: Vượt quá hạn mức Ứng trước trong ngày của KH!', '[-100156]: Exceed the limit of advance of the day of the customer!', 'CF', NULL);COMMIT;