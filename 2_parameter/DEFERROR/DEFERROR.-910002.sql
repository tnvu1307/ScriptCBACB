SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -910002;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-910002, '[-910002]: Tồn tại một mã chứng khoán đã được định giá cho đợt phát hành này!', '[-910002]: There exists a ticker that has been priced for this issue!', 'BA', 0);COMMIT;