SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -670009;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-670009, '[-670009]: Chữ ký không đúng', '[-670009]: Invalid signature', 'RM', 0);COMMIT;