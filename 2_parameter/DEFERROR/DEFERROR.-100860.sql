SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100860;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100860, '[-100860]: TRADERNAME bị trùng !', '[-100860]: TRADERNAME DUPLICATE!', 'DL', NULL);COMMIT;