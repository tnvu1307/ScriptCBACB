SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100116;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100116, '[-100116]:Khong duoc doi sang loai hinh hop dong khac!', '[-100116]:Cannot change to other contract type!', 'SA', NULL);COMMIT;