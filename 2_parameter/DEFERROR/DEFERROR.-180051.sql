SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -180051;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-180051, '[-180051]:Loại hợp đồng không phù hợp!', '[-180051]:Contract type does not match!', 'SE', NULL);COMMIT;