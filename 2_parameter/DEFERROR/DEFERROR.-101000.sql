SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -101000;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-101000, '[-101000]: Trừng mã nhóm !', '[-101000]: Group ID is duplicated!', 'SA', NULL);COMMIT;