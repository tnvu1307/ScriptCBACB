SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -900034;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-900034, '[-900034] Vượt quá số dư chứng khoán có thể giải tỏa ', '[-900034]:Hold quantity not enough!', 'SE', NULL);COMMIT;