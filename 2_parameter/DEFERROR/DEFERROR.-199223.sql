SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -199223;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-199223, '[-199223]: Nội dung điện MT568 chỉ được phép nhập tối đa 10 dòng!', '[-199223]: Content of MT568 is only allowed a maximum of 10 lines!', 'SA', NULL);COMMIT;