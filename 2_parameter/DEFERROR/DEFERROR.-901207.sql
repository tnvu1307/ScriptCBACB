SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -901207;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-901207, '[-901207]: Số lượng cầm cố lên trung tâm không hợp lệ', '[-901207]: VSD_DF quantity invalid!', 'SE', NULL);COMMIT;