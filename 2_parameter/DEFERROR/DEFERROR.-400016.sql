SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400016;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400016, '[-400016]: Không thể xoá số tài khoản tiền gửi do vẫn còn dữ liệu liên quan!', '[-400016]: Cannot delete the CI account number  which contains related data!', 'CI', NULL);COMMIT;