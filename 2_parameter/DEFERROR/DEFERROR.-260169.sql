SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260169;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260169, '[-260169]: Khách hàng vẫn còn nợ phí !', '[-260169]: Customers still owe fees !', 'SA', NULL);COMMIT;