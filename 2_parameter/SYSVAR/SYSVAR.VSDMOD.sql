SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('VSDMOD','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'VSDMOD', 'A', 'A - Auto, M - Manual', 'A - Auto, M - Manual', 'N', 'C');COMMIT;