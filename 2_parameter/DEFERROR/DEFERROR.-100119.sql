SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100119;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100119, '[-100119]:Bạn không được làm do hệ thống đã thực hiện bước xử lý trước chạy batch!', '[-100119]: System process before batch already', 'SA', NULL);COMMIT;