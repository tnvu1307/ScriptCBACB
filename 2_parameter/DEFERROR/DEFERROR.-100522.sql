SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100522;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100522, '[-100522]: Vượt quá quy định của nguồn tiền!', '[-100522]: Exceed cash limit!', 'SA', NULL);COMMIT;