SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('HOSESENDSIZE','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'HOSESENDSIZE', '50', 'Send to HOSE queue size', 'Send to HOSE queue size', 'N', 'C');COMMIT;