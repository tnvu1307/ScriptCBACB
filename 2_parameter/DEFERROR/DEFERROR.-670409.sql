SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -670409;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-670409, '[-670409]: Số tiền giảm phải nhỏ hơn Số tiền chờ chuyển đi của tài khoản tiền hiện tại', '[-670409]: The reduced amount must be less than the current account''s pending amount', 'RM', 0);COMMIT;