SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -100099;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-100099, '[-100099]: Bước xử lý batch phải xử lý tuần tự, kiểm tra các bước chưa thực hiện!', '[-100099]: ERR_BATCH_PROCESS_FOLLOW_SEQUENCE', 'SA', NULL);COMMIT;