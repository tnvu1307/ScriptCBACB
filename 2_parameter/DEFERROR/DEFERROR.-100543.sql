SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100543;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100543, '[-100543]: Chứng khoán chuyển không hợp lệ !', '[-100543]: Transfer securities code not valid !', 'PR', NULL);COMMIT;