SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -912000;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-912000, '[-912000]: Giá trị thanh toán không hợp lệ!', '[-912000]: Net amount invalid!', 'AP', 0);COMMIT;