SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -900143;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-900143, '[-900143]: Không đủ số lượng CK tạm giữ để giải tỏa', '[-900143]: Not enough block quantity to unblock!', 'SE', NULL);COMMIT;