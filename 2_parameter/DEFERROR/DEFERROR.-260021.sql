SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260021;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260021, '[-260021]: Nơi cho vay không đúng!', '[-260021]: ERR_DF_DFTYPE_L_NOT_ALLOW_RRTYPE_O!', 'DF', NULL);COMMIT;