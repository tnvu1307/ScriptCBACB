SET DEFINE OFF;DELETE FROM SBBATCHCTL WHERE 1 = 1 AND NVL(BCHMDL,'NULL') = NVL('HOLDEBITDATE','NULL');Insert into SBBATCHCTL   (BCHSQN, APPTYPE, BCHMDL, BCHTITLE, RUNAT, ACTION, RPTPRINT, TLBCHNAME, MSG, BKP, BKPSQL, RSTSQL, ROWPERPAGE, RUNMOD, STATUS) Values   ('0039', 'CA', 'HOLDEBITDATE', 'Hold tiền đăng ký quyền mua tự động', 'EOD', ' ', 'N', 'HDTD', 'Hold tiền đăng ký quyền mua tự động...', ' ', ' ', ' ', 2000, 'DB', 'Y');COMMIT;