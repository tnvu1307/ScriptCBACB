SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400450;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400450, '[-400450]: Chỉ hủy được giao dịch thực hiện trong ngày', '[-400450]: Can only delete transaction within the day!', 'SE', NULL);COMMIT;