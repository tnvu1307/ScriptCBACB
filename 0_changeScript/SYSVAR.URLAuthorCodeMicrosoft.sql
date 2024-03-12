SET DEFINE OFF;

DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('URLAuthorCodeMicrosoft','NULL');

Insert into SYSVAR
   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE)
 Values
   ('SYSTEM', 'URLAuthorCodeMicrosoft', 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize', 'API dùng để xác thực đăng nhập Microsoft', NULL, 'Y', 'C');
COMMIT;

