SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260035;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260035, '[-260035]: Tài sản quy đổi, tổng nợ đã bị thay đổi !', '[-260035]: Asset collateral and total outsating are changed!', 'DF', NULL);COMMIT;