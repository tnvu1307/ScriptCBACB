SET DEFINE OFF;

DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('ClientSecretMicrosoft','NULL');

Insert into SYSVAR
   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE)
 Values
   ('SYSTEM', 'ClientSecretMicrosoft', 'zTM8Q~dh7z3rpVbnVQA64j9hB-S2.LlPyBrioaEx', 'Secret Id dùng để xác thực Microsoft', NULL, 'Y', 'C');
COMMIT;
