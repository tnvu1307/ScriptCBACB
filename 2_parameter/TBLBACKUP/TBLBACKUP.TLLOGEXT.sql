SET DEFINE OFF;DELETE FROM TBLBACKUP WHERE 1 = 1 AND NVL(FRTABLE,'NULL') = NVL('TLLOGEXT','NULL');Insert into TBLBACKUP   (FRTABLE, TOTABLE, TYPBK) Values   ('TLLOGEXT', 'TLLOGEXTHIST', 'D');COMMIT;