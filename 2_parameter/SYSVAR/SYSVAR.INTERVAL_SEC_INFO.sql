SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('INTERVAL_SEC_INFO','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'INTERVAL_SEC_INFO', '30000', '', '', 'N', 'C');COMMIT;