SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100807;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100807, '[-100807]: Tiểu khoản đã được gán vào nhóm tính phí !', '[-100807]: Account already assign to broker fee group', 'SA', NULL);COMMIT;