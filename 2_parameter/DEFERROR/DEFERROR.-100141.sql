SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100141;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100141, '[-100141]:Chuyển đổi loại hình không thành công!. Tiểu khoản tồn tại lệnh chưa thực hiện thanh toán!', '[-100141]: Change cannit be made. Order still pending for clearing', 'CF', NULL);COMMIT;