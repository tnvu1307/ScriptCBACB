SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -300013;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-300013, '[-300013]: Trạng thái của sự kiện thực hiện quyền không hợp lệ !', '[-300013]: Status of CA is invalid!', 'CA', NULL);COMMIT;