SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200409;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200409, '[-200409]:Chính sách mua bán trùng với chính sách mua bán đã khai báo cùng tiểu khoản!', '[-200409]:Trading policy on sub acocunt duplicate !', 'CF', NULL);COMMIT;