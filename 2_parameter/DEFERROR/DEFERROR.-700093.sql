SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -700093;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-700093, '[-700093]: Mã chứng khoán không tồn tại trong hệ thống! ', '[-700093]: Not exists the symbol in system!', 'SE', 0);COMMIT;