SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -670063;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-670063, '[-670063]:Lệnh tạm giữ hiện tại không thể chia', '[-670063]: Hold ID cannot split', 'RM', 0);COMMIT;