SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100828;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100828, '[-100828]: TRADERNAME không đúng!', '[-100828]: TRADERNAME is false', 'DL', NULL);COMMIT;