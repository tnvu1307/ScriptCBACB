SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260005;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260005, '[-260005] Trả quá số tiền phải thanh toán cho deal', '[-260005] Exceed payable amount!', 'DF', NULL);COMMIT;