SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100601;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100601, '[-100601] User ko duoc cap han muc margin', '[-100601] ERR_SA_USER_HAVE_NO_MARGIN_LIMIT', 'CF', NULL);COMMIT;