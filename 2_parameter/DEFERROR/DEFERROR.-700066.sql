SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -700066;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-700066, '[-700066]: Số ngày trả chậm phải nằm trong khoản 0 đến 2', '[-700066]: Late payment  day from 0 to 2', 'OD', NULL);COMMIT;