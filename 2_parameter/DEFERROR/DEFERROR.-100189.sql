SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100189;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100189, '[-100189]: Phí có bậc thang', '[-100189]: Fee tier already exists', 'SA', 0);COMMIT;