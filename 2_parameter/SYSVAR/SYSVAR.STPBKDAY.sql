SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('STPBKDAY','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'STPBKDAY', '180', 'Số ngày backup các view tra cứu lịch sử VSD', 'Time for backup VSD view', 'N', 'C');COMMIT;