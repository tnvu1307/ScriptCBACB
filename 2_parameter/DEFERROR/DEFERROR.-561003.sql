SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -561003;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-561003, 'Không tìm thấy môi giới', 'RE NOT FOUND', 'RE', NULL);COMMIT;