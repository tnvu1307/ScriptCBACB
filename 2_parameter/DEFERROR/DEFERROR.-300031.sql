SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -300031;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-300031, '[-300031]: Quá ngày cho phép thực hiện chuyển nhượng quyền mua, ', '[-300031]: ERR_CA_DATE_OUTOF_REGISTER', 'CA', NULL);COMMIT;