SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -900048;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-900048, '[-900048]: Giao dịch đã được xóa trước đó !', '[-900048]: DELETED BEFORE !', 'SE', NULL);COMMIT;