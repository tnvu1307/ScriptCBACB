SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100821;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100821, '[-100821]: LEVELCD và REFID không hợp lệ !', '[-100821]: LEVELCD and REFID invalid!', 'DL', NULL);COMMIT;