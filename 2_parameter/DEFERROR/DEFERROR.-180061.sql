SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -180061;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-180061, '[-180061]: Ngày GD không phải ngày đến hạn, không được thay đổi lãi/phí đến hạn!', '[-180061]: Trading date is not due date, can not change interest/fee due!', 'MR', NULL);COMMIT;