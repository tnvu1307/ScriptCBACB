SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('OTPSMSDISABLETIME','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'OTPSMSDISABLETIME', '10', 'Thoi gian disable nut nhan SMS', 'Thoi gian disable nut nhan SMS', 'Y', 'C');COMMIT;