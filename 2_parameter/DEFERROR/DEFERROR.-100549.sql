SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100549;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100549, '[-100549]: Giá trị nguồn tăng thêm phải dương !', '[-100549]: Increased value must be greater than 0 !', 'PR', NULL);COMMIT;