SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -911008;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-911008, '[-911008]: Phải thực hiện unhold trước khi thanh toán', '[-911008]: Must make unhold before payment', 'OD', NULL);COMMIT;