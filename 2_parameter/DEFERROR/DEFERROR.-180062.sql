SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -180062;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-180062, '[-180062]: Ngày GD nhỏ hơn ngày đến hạn, không được thay đổi lãi/phí quá hạn!', '[-180062]: Trading date is earlier than due date, can not change interest/fee due!', 'MR', NULL);COMMIT;