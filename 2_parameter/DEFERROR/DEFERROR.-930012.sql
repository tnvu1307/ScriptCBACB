SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -930012;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-930012, '[-930012] : Error when excecute transaction id 9214', '[-930012] : Error when excecute transaction id 9214', 'FA', 0);COMMIT;