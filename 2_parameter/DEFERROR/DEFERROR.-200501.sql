SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -200501;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-200501, '[-200501]: Vẫn còn giao dịch đang chờ xử lý, quý khách vui lòng thực hiện giao dịch sau ít phút!', '[-200501]: Still remain pending transaction, Please do again after a few minutes!', 'CF', NULL);COMMIT;