SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100552;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100552, '[-100552]: Không được xóa Room đã được sử dụng!', '[-100552]: Room inuse, cannot delete!', 'PR', NULL);COMMIT;