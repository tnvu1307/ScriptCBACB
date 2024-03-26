SET DEFINE OFF;

DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('ScopeMicrosoftGraph','NULL');

Insert into SYSVAR
   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE)
 Values
   ('SYSTEM', 'ScopeMicrosoftGraph', 'User.Read', 'Phạm vi quyền được cấp sau khi xác thực Microsoft', NULL, 'Y', 'C');
COMMIT;

