SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100517;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100517, 'ERR_PRDETAIL_DUPLICATED: Loại hình Pool/Room này đã được thiết lập cho chi nhánh', 'ERR_PRDETAIL_DUPLICATED: Pool/Room already set up!', 'SA', NULL);COMMIT;