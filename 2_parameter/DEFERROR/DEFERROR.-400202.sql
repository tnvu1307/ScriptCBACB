SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400202;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400202, '[-400202]: Trạng thái yêu cầu không cho phép từ chối', '[-400202]: Request status not allow to reject', 'CI', NULL);COMMIT;