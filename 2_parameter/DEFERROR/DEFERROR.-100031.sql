SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100031;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100031, '[-100031]: Khoảng giá của chứng khoán này bị trùng!', '[-100031]: Secticksize is duplicated!', 'SA', NULL);COMMIT;