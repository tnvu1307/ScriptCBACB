SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -561016;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-561016, '[-561016] Trùng mã phí giảm trừ', '[-561016]Duplicate rerfee code', 'RE', 0);COMMIT;