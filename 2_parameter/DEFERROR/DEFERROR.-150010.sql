SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -150010;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-150010, '[-150010]: Tài khoản nhận, cắt tiền không hợp lệ!', '[-150010]: Invalid credit and debit account!', 'ST', NULL);COMMIT;