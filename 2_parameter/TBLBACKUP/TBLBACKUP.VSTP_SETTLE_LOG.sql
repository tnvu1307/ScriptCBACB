SET DEFINE OFF;DELETE FROM TBLBACKUP WHERE 1 = 1 AND NVL(FRTABLE,'NULL') = NVL('VSTP_SETTLE_LOG','NULL');Insert into TBLBACKUP   (FRTABLE, TOTABLE, TYPBK) Values   ('VSTP_SETTLE_LOG', 'VSTP_SETTLE_LOGHIST', 'N');COMMIT;