SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100118;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100118, '[-100118]:Mã phí không tồn tại', '[-100118]:ERR_SA_FEEMAP_FEECD_DOESNOT_EXISTS', 'SA', NULL);COMMIT;