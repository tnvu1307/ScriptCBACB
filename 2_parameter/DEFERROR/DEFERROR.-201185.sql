SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -201185;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-201185, '[-201185]: Phải bán hết số lượng ck lẻ của tài khoản !', '[-201185]: Must sell all odd lot quantity!', 'SE', NULL);COMMIT;