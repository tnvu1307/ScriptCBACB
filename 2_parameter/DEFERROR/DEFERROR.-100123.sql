SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100123;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100123, '[-100123]: Không thể xoá dữ liệu khi còn giao dịch liên quan', '[-100123]: CAN NOT DELETE', 'SA', 0);COMMIT;