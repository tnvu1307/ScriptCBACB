SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260004;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260004, '[-260004] Không thể phong toả chứng khoán nhận về', '[-260004] Can not block receivable stocks', 'DF', NULL);COMMIT;