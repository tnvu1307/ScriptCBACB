SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200042;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200042, 'Phải nhập mã số thuế', '[-200042]: ERR_CF_TAXCODE_ISNOT_NULL!', 'CF', NULL);COMMIT;