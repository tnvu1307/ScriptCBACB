SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -900020;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-900020, '[-900020]: Số dư cầm cố không đủ ', '[-900020]: DF balance not enough!', 'SE', NULL);COMMIT;