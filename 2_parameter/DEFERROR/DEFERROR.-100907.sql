SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100907;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100907, '[-100907]: Loại biểu phí riêng cho số TK lưu ký này đã tồn tại!', '[-100907]: A separate fee type for this account already exists!', 'SA', 0);COMMIT;