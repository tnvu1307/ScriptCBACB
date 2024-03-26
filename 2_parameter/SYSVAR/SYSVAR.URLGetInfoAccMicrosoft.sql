SET DEFINE OFF;

DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('URLGetInfoAccMicrosoft','NULL');

Insert into SYSVAR
   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE)
 Values
   ('SYSTEM', 'URLGetInfoAccMicrosoft', 'https://graph.microsoft.com/v1.0/me', 'API dùng để lấy thông tin account Microsoft', NULL, 'Y', 'C');
COMMIT;

