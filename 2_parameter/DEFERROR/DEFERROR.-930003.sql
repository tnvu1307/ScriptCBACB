SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -930003;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-930003, '[-930003] : Can not handle unknown event', '[-930003] : Can not handle unknown event', 'FA', 0);COMMIT;