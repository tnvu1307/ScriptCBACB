SET DEFINE OFF;DELETE FROM SBBATCHCTL WHERE 1 = 1 AND NVL(BCHMDL,'NULL') = NVL('SASENDSWIFT','NULL');Insert into SBBATCHCTL   (BCHSQN, APPTYPE, BCHMDL, BCHTITLE, RUNAT, ACTION, RPTPRINT, TLBCHNAME, MSG, BKP, BKPSQL, RSTSQL, ROWPERPAGE, RUNMOD, STATUS) Values   ('1001', 'SA', 'SASENDSWIFT', 'Tự động gửi điện báo cáo', 'EOD', ' ', 'N', 'SDSW', 'Auto send report...', ' ', ' ', ' ', 0, 'DB', 'Y');COMMIT;