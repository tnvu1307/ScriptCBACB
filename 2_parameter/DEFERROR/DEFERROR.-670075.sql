SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -670075;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-670075, '[-670075]: Bảng kê đã được gửi trước đó, không thể gửi', '[-670075]: Can not send, List sent already!', 'RM', 0);COMMIT;