SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('EMAILTEST','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'EMAILTEST', 'quynhdiem291096@gmail.com,dantepro0000@gmail.com', 'Email test', 'Email test', 'Y', 'C');COMMIT;