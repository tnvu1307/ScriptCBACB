SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -180032;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-180032, '[-180032]: Quá hạn mức tối đa được cấp cho khách hàng', '[-180032]:Exceed max limit allocated!', 'MR', NULL);COMMIT;