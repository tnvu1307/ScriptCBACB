SET DEFINE OFF;DELETE FROM TBLBACKUP WHERE 1 = 1 AND NVL(FRTABLE,'NULL') = NVL('STCORDERBOOKTEMP','NULL');Insert into TBLBACKUP   (FRTABLE, TOTABLE, TYPBK) Values   ('STCORDERBOOKTEMP', 'STCORDERBOOKTEMP', 'D');COMMIT;