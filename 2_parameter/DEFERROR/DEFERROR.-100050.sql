SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100050;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100050, '[-100050]: Tên nhóm này đã tồn tại!', '[-100050]: Group name is duplicated!', 'SA', NULL);COMMIT;