SET DEFINE OFF;

DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('RedirectUriMicrosoft','NULL');

Insert into SYSVAR
   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE)
 Values
   ('SYSTEM', 'RedirectUriMicrosoft', 'https://localhost:52514', 'URL dùng để hứng code từ Microsoft trả về khi xác thực', NULL, 'Y', 'C');
COMMIT;

