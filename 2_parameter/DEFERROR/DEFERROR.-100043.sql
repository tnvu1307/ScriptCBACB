SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100043;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100043, '[-100043]: NSD này đã có trong DS phân quyền!', '[-100043]: This user is existed in assignment list!', 'SA', NULL);COMMIT;