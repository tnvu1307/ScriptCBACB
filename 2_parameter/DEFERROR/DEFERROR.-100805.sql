SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100805;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100805, '[-100805]: Loại hình AF này đã có loại hình AD cho phép tự động ứng trước, không được gán thêm AD cho phép tự động ứng trước nữa.!', '[-100805]: Auto AD type already assigned. Can not assign!', 'SA', NULL);COMMIT;