SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -300056;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-300056, '[-300056] Số quyền yêu cầu hủy lớn hơn số quyền còn lại', '[-300056] The quantity of rights to be cancelled is bigger than the quantity of remaining rights', 'CA', NULL);COMMIT;