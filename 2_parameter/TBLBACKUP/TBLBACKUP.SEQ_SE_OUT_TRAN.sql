SET DEFINE OFF;DELETE FROM TBLBACKUP WHERE 1 = 1 AND NVL(FRTABLE,'NULL') = NVL('SEQ_SE_OUT_TRAN','NULL');Insert into TBLBACKUP   (FRTABLE, TOTABLE, TYPBK) Values   ('SEQ_SE_OUT_TRAN', 'SEQ_SE_OUT_TRAN', 'S');COMMIT;