SET DEFINE OFF;DELETE FROM TBLBACKUP WHERE 1 = 1 AND NVL(FRTABLE,'NULL') = NVL('SEQ_BANKREFTCDT1201','NULL');Insert into TBLBACKUP   (FRTABLE, TOTABLE, TYPBK) Values   ('SEQ_BANKREFTCDT1201', 'SEQ_BANKREFTCDT1201', 'S');COMMIT;