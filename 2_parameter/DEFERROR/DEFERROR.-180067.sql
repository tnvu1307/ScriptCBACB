SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -180067;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-180067, '[-180067]: Khách hàng chưa được phép Margin! ', '[-180067]: CUSTOMER MARGIN STATUS NOT ALLOW', 'CF', NULL);COMMIT;