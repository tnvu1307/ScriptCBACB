SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = 231;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (231, '[231]:  Lệnh mua đối ứng đang chờ khớp!', '[231]:  Correspondent buying order pending!', 'SA', NULL);COMMIT;