SET DEFINE OFF;DELETE FROM TBLBACKUP WHERE 1 = 1 AND NVL(FRTABLE,'NULL') = NVL('STCTRADEBOOKBUFFER','NULL');Insert into TBLBACKUP   (FRTABLE, TOTABLE, TYPBK) Values   ('STCTRADEBOOKBUFFER', 'STCTRADEBOOKBUFFER', 'D');COMMIT;