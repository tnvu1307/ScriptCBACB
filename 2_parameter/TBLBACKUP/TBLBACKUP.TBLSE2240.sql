SET DEFINE OFF;DELETE FROM TBLBACKUP WHERE 1 = 1 AND NVL(FRTABLE,'NULL') = NVL('TBLSE2240','NULL');Insert into TBLBACKUP   (FRTABLE, TOTABLE, TYPBK) Values   ('TBLSE2240', 'TBLSE2240HIST', 'N');COMMIT;