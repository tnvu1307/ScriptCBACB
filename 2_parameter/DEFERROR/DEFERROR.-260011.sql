SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -260011;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-260011, '[-260011] Danh sách chi tiết chứng khoán phong toả không tồn tại', '[-260011] Detail list of blocked stocks not existed', 'DF', NULL);COMMIT;