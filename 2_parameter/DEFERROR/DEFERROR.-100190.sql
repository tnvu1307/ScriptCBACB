SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100190;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100190, '[-100190]: Trùng mã đợt phát hành', '[-100190]: Issue code already exists', 'SA', 0);COMMIT;