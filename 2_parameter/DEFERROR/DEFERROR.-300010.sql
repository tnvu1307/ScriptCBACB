SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -300010;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-300010, '[-300010]: Sự kiện quyền đã duyệt không được phép xóa!', '[-300010]: The approved CA isn''t deleted', 'CA', NULL);COMMIT;