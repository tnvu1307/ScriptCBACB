SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('TRADEBUYSELLPT','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'TRADEBUYSELLPT', 'N', 'Neu Y thi cho phep dat lenh thoa thuan doi ung ', '', 'N', 'C');COMMIT;