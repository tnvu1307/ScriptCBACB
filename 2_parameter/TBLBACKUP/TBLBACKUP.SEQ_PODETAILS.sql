SET DEFINE OFF;DELETE FROM TBLBACKUP WHERE 1 = 1 AND NVL(FRTABLE,'NULL') = NVL('SEQ_PODETAILS','NULL');Insert into TBLBACKUP   (FRTABLE, TOTABLE, TYPBK) Values   ('SEQ_PODETAILS', 'SEQ_PODETAILS', 'S');COMMIT;