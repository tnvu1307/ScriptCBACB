SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -900032;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-900032, '[-900032]: Chứng khoán OTC chờ chuyển', '[-900032]: ERR_SE_TRANSFER', 'SE', NULL);COMMIT;