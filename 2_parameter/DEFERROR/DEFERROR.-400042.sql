SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400042;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400042, '[-400042]: ERR_CI_PENDINGUNHOLDBALANCE', '[-400042]: ERR_CI_PENDINGUNHOLDBALANCE', 'CI', NULL);COMMIT;