SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('HSX_MAXBREAKSIZE_CNT','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'HSX_MAXBREAKSIZE_CNT', '2000', 'Sá»‘ lá»‡nh tÃ¡ch tá»‘i Ä‘a', 'HSX: Maximum order break size', 'N', 'C');COMMIT;