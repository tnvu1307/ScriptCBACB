SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400113;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400113, '[-400113]:Vượt quá số dư đã hold tại ngân hàng!', '[-400113]:Exceed Hold balance', 'CI', NULL);COMMIT;