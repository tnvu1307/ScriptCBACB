SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('BRPHONEFAX','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'BRPHONEFAX', 'Điện thoại: (84.28) 3528 7900 Fax: (84.28) 3620 4400', 'Branch phone & fax number', NULL, 'Y', 'C');COMMIT;