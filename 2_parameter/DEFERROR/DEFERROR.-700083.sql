SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -700083;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-700083, '[-700083]: Lệnh sửa lỗi chưa được khớp hết!', '[-700083]: Correcting orders not yet fully matched!', 'OD', NULL);COMMIT;