SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100861;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100861, '[-100861]: TRADERNAME không tồn tại !', '[-100861]: TRADERNAME NOT EXIST!', 'DL', NULL);COMMIT;