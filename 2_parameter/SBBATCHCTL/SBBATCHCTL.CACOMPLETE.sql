SET DEFINE OFF;DELETE FROM SBBATCHCTL WHERE 1 = 1 AND NVL(BCHMDL,'NULL') = NVL('CACOMPLETE','NULL');Insert into SBBATCHCTL   (BCHSQN, APPTYPE, BCHMDL, BCHTITLE, RUNAT, ACTION, RPTPRINT, TLBCHNAME, MSG, BKP, BKPSQL, RSTSQL, ROWPERPAGE, RUNMOD, STATUS) Values   ('3023', 'CA', 'CACOMPLETE', 'Tự động hoàn tất sự kiện quyền', 'EOD', ' ', 'N', 'CA', 'Auto Complete CA', ' ', ' ', ' ', 0, 'DB', 'Y');COMMIT;