SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -701111;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-701111, '[-701111]: KL sửa phải lớn hơn khối lượng đã khớp', '[-701111]: Adjust QTTY must be greater than matched amount', 'OD', NULL);COMMIT;