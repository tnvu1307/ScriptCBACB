SET DEFINE OFF;DELETE FROM SBBATCHCTL WHERE 1 = 1 AND NVL(BCHMDL,'NULL') = NVL('SAAFB','NULL');Insert into SBBATCHCTL   (BCHSQN, APPTYPE, BCHMDL, BCHTITLE, RUNAT, ACTION, RPTPRINT, TLBCHNAME, MSG, BKP, BKPSQL, RSTSQL, ROWPERPAGE, RUNMOD, STATUS) Values   ('9999', 'SA', 'SAAFB', 'Xử lý khởi tạo dữ liệu cuối chạy batch', 'BOD', ' ', 'N', 'SAA', 'Xử lý khởi tạo dữ liệu cuối chạy batch...', ' ', ' ', ' ', 0, 'DB', 'Y');COMMIT;