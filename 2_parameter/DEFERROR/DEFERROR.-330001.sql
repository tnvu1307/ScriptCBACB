SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -330001;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-330001, '[-330001]: Tài khoản không tham gia sự kiện quyền mua!', '[-330001]: Accounts not attend the event right to buy!', 'CA', NULL);COMMIT;