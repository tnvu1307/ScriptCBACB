SET DEFINE OFF;DELETE FROM SBBATCHCTL WHERE 1 = 1 AND NVL(BCHMDL,'NULL') = NVL('EODSENDEMAIL','NULL');Insert into SBBATCHCTL   (BCHSQN, APPTYPE, BCHMDL, BCHTITLE, RUNAT, ACTION, RPTPRINT, TLBCHNAME, MSG, BKP, BKPSQL, RSTSQL, ROWPERPAGE, RUNMOD, STATUS) Values   ('0050', 'SA', 'EODSENDEMAIL', 'Tự động gửi email cuối ngày', 'EOD', '', 'N', 'SAEM', 'Tự động gửi email cuối ngày...', ' ', ' ', ' ', 1000, 'DB', 'Y');COMMIT;