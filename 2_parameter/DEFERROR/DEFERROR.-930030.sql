SET DEFINE OFF;DELETE FROM DEFERROR WHERE 1 = 1 AND ERRNUM = -930030;Insert into DEFERROR   (ERRNUM, ERRDESC, EN_ERRDESC, MODCODE, CONFLVL) Values   (-930030, '[-930030]: Loại tài sản TPRL phải nguồn VSD!', '[-930030]: TPRL property type must source VSD!', 'CF', 0);COMMIT;