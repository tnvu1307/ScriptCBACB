SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -300048;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-300048, '[-300048]:Vẫn còn tiểu khoản chưa được phân bổ chứng khoán hoặc tiền', '[-300048]:Allocating money and securities not finished!', 'CA', NULL);COMMIT;