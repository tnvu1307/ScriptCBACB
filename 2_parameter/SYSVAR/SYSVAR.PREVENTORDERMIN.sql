SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('PREVENTORDERMIN','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'PREVENTORDERMIN', 'Y', 'Prevent min amount order', 'Prevent min amount order', 'N', 'C');COMMIT;