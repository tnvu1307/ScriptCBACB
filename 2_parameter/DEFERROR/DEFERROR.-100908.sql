SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100908;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100908, '[-100908]: Phí có bậc thang', '[-100908]: Fee tier already exists', 'SA', 0);COMMIT;