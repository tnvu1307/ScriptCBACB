SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -700017;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-700017, '[-700017: Không được phép sửa lệnh khi đang có lệnh đối ứng tại phiên ATC.', '[-700017]: Not allowed to edit order while a warrant counterpart in ATC session.', 'OD', NULL);COMMIT;