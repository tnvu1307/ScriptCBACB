SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400041;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400041, '[-400041]: ERR_CI_PENDINGHOLDBALANCE', '[-400041]: ERR_CI_PENDINGHOLDBALANCE', 'CI', NULL);COMMIT;