SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('2REFNAME','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('REPRESENT', '2REFNAME', 'Nguyễn Ngọc Phương Trang', 'Nguyễn Ngọc Phương Trang', 'Nguyen Ngoc Phuong Trang', 'Y', 'C');COMMIT;