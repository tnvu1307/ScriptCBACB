SET DEFINE OFF;DELETE FROM SBBATCHCTL WHERE 1 = 1 AND NVL(BCHMDL,'NULL') = NVL('FEEBKAUTO','NULL');Insert into SBBATCHCTL   (BCHSQN, APPTYPE, BCHMDL, BCHTITLE, RUNAT, ACTION, RPTPRINT, TLBCHNAME, MSG, BKP, BKPSQL, RSTSQL, ROWPERPAGE, RUNMOD, STATUS) Values   ('2021', 'SA', 'FEEBKAUTO', 'Tự động thu phí', 'BOD', '', 'N', 'SBKA', 'Tự động thu phi cuối ngày...', ' ', ' ', ' ', 500, 'DB', 'Y');COMMIT;