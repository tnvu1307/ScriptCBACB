SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100222;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100222, '[-100222]: Vẫn còn tiểu khoản trong loại hình này!', '[-100222]:ERR_SA_STILL_HAS_AF_INUSE', 'SA', NULL);COMMIT;