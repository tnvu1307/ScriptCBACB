SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -700001;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-700001, '[-700001]: gc_ERRCODE_OD_ACTYPE_DUPLICATED', '[-700001]: gc_ERRCODE_OD_ACTYPE_DUPLICATED', 'OD', NULL);COMMIT;