SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -400445;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-400445, '[-400445]: Vượt quá số lượng cho phép', '[-400445]: BLOCK NOT enough', 'SE', NULL);COMMIT;