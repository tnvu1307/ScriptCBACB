SET DEFINE OFF;DELETE FROM SYSVAR WHERE 1 = 1 AND NVL(VARNAME,'NULL') = NVL('OTPRETRYCNT','NULL');Insert into SYSVAR   (GRNAME, VARNAME, VARVALUE, VARDESC, EN_VARDESC, EDITALLOW, DATATYPE) Values   ('SYSTEM', 'OTPRETRYCNT', '3', 'So lan có the nhap', 'Retry OTP count max', 'Y', 'C');COMMIT;