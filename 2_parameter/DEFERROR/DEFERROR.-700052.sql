SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -700052;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-700052, '[-700052]: ERR_OD_TRADEPLACE_HOSE_NOT_AMEND', '[-700052]: ERR_OD_TRADEPLACE_HOSE_NOT_AMEND', 'OD', NULL);COMMIT;