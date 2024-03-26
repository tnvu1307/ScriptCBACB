SET DEFINE OFF;

DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('SecondsLimitAFK','NULL');

Insert into SYSVAR
   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE)
 Values
   ('SYSTEM', 'SecondsLimitAFK', '3600', 'Thời gian tối đa mà người dùng không connect với HOST, sau đó sẽ bắt đăng nhập lại', NULL, 'Y', 'C');
COMMIT;

