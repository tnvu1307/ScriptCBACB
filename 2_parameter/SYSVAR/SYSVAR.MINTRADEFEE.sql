SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('MINTRADEFEE','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('DEFINED', 'MINTRADEFEE', '0', 'Min trading fee', 'Phi giao dich toi thieu', 'N', 'C');COMMIT;