SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -300038;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-300038, '[-300038]: Tỷ lệ tách phải nhỏ hơn 1 !', '[-300038]:Split rate must be less than 1', 'CA', NULL);COMMIT;