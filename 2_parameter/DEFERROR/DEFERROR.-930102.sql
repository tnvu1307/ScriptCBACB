SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -930102;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-930102, '[-930102]: Phí VND không được có phần lẻ thập phân', '[-930102]: The VND fee should not include decimal', 'OD', 0);COMMIT;