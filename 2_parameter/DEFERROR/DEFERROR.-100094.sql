SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100094;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100094, '[-100094]: Nhom nay dang quan ly khach hang!', '[-100094]: This group is caring customers!', 'CF', NULL);COMMIT;