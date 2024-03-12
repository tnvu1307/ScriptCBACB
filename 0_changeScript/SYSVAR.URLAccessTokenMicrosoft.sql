SET DEFINE OFF;

DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('URLAccessTokenMicrosoft','NULL');

Insert into SYSVAR
   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE)
 Values
   ('SYSTEM', 'URLAccessTokenMicrosoft', 'https://login.live.com/oauth20_token.srf', 'API dùng để lấy AccessToken Microsoft', NULL, 'Y', 'C');
COMMIT;

