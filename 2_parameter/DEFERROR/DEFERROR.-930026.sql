SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -930026;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-930026, '[-930026] : 111611: Trạng thái phí liên quan đang là "KHÔNG" (không hợp lệ)', '[-930026] : Check tariff 111611: the related fee''s status is "NO" (invalid)', 'FA', 0);COMMIT;