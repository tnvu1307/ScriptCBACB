SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -700068;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-700068, '[-700068]: Số ngày trả chậm và tỉ lệ trả chậm đồng thời phải bằng 0 hoặc khác 0!', '[-700068]: Bpth Late payment  day and ratio must be 0 or not 0', 'OD', NULL);COMMIT;