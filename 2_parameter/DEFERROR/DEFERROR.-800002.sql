SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -800002;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-800002, '[-800002]: Lệnh không được hủy do đã khớp hết hoặc đã được yêu cầu hủy sửa rồi!', '[-800002]: gc_ERRCODE_FO_INVALID_STATUS', 'FO', NULL);COMMIT;