SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260036;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260036, '[-260036]: Chưa xác nhận cầm cố VSD', '[-260036]: ERR_DF_NOT_CONFIRM_VSD!', 'DF', NULL);COMMIT;