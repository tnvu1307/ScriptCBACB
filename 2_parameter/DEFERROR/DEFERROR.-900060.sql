SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -900060;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-900060, '[-900060]: Ngày cầm cố phải lớn hơn ngày yêu cầu cầm cố', '[-900060]: Mortgage date must be later than request date', 'SE', NULL);COMMIT;