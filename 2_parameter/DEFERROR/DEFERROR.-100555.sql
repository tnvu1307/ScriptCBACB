SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100555;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100555, '[-100555]: Ngày hiệu lực không được nhỏ hơn ngày hiện tại!', '[-100555]: Effective date cant less than today !', 'PR', NULL);COMMIT;