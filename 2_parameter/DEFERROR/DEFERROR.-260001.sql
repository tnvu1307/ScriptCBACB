SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260001;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260001, '[-260001] Loại hình DF không tồn tại', '[-260001] DF type not exist', 'DF', NULL);COMMIT;