SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100845;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100845, '[-100845]: Loại hình tiểu khoản đã được sử dụng, không cho phép chuyển đổi loại hình margin khác nhớm!', '[-100845]: In use sub acc type, can not change margin type!', '', NULL);COMMIT;