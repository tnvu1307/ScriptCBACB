SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -701415;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-701415, '[-701415]: Không thể bán vượt quá số lượng cầm cố có thể giao dịch.', '[-701415]: Unable to sell the mortage amount has reached tradable.', 'OD', NULL);COMMIT;