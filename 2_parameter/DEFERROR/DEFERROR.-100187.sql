SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100187;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100187, '[-100187]: Mã phí đã tồn tại', '[-100187]: Fee code already exists', 'SA', 0);COMMIT;