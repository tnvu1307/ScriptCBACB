SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('ITMOBILESMS','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'ITMOBILESMS', '2', 'So dien thoai dung de nhan tin cho IT khi co loi xay ra', 'So dien thoai dung de nhan tin cho IT khi co loi xay ra', 'N', 'C');COMMIT;