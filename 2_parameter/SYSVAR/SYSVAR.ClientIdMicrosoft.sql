SET DEFINE OFF;

DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('ClientIdMicrosoft','NULL');

Insert into SYSVAR
   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE)
 Values
   ('SYSTEM', 'ClientIdMicrosoft', '88a5538d-b86b-430b-912a-1f18f5e3d819', 'ID dùng để xác thực Microsoft', NULL, 'Y', 'C');
COMMIT;
