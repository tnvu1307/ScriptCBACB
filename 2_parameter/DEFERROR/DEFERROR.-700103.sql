SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -700103;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-700103, '[-700103]: Lệnh hủy sai phiên', '[-700103]: Order cancel in wrong session!', 'OD', NULL);COMMIT;