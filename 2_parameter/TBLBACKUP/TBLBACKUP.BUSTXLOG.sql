SET DEFINE OFF;DELETE FROM TBLBACKUP WHERE 1 = 1 AND NVL(FRTABLE,'NULL') = NVL('BUSTXLOG','NULL');Insert into TBLBACKUP   (FRTABLE, TOTABLE, TYPBK) Values   ('BUSTXLOG', 'BUSTXLOGHIST', 'D');COMMIT;