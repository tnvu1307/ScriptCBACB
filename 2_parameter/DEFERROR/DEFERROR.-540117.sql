SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -540117;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-540117, 'Loan type of loan account and contract account must be the same!', 'Loan type of loan account and contract account must be the same!', 'LN', NULL);COMMIT;