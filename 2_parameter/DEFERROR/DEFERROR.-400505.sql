SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400505;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400505, '[-400505]: Nguồn VSD TPRL "Số hiệu lệnh VSD" là bắt buộc!', '[-400505]: Source VSD PPBs "VSD ORDERID" is required!', 'OD', NULL);COMMIT;