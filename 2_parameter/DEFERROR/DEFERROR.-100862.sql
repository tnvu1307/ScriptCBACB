SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100862;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100862, '[-100862]: TRADERNAME và SYMBOL bị trùng !', '[-100862]: TRADERNAME AND SYMBOL DUPLICATE!', 'DL', NULL);COMMIT;