SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100306;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100306, '[-100306]: TK Quản lý quỹ không tồn tại', '[-100306]: FA MemberID not exists', 'SA', NULL);COMMIT;