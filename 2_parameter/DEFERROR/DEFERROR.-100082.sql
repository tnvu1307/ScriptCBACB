SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100082;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100082, '[-100082]: Ngày hiệu lực phải lớn hơn ngày hiện tại!', '[-100082] :Effective date must be later than current date!', 'SA', NULL);COMMIT;