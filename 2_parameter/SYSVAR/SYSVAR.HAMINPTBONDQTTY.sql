SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('HAMINPTBONDQTTY','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('OD', 'HAMINPTBONDQTTY', '1000', 'Khoi luong CK toi thieu cho phep dat lenh trai phieu thoa thuan san HA', 'Khoi luong CK toi thieu cho phep dat lenh trai phieu thoa thuan san HA', 'N', 'C');COMMIT;