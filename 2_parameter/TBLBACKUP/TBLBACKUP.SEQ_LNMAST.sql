SET DEFINE OFF;DELETE FROM TBLBACKUP WHERE 1 = 1 AND NVL(FRTABLE,'NULL') = NVL('SEQ_LNMAST','NULL');Insert into TBLBACKUP   (FRTABLE, TOTABLE, TYPBK) Values   ('SEQ_LNMAST', 'SEQ_LNMAST', 'S');COMMIT;