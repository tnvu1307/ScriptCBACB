SET DEFINE OFF;DELETE FROM SBBATCHCTL WHERE 1 = 1 AND NVL(BCHMDL,'NULL') = NVL('CASEND','NULL');Insert into SBBATCHCTL   (BCHSQN, APPTYPE, BCHMDL, BCHTITLE, RUNAT, ACTION, RPTPRINT, TLBCHNAME, MSG, BKP, BKPSQL, RSTSQL, ROWPERPAGE, RUNMOD, STATUS) Values   ('4010', 'CA', 'CASEND', 'Tự động gửi cho sự kiện quyền đến ngày gửi', 'BOD', ' ', 'N', 'CAEX', 'Tự động gửi cho sự kiện quyền đến ngày gửi', ' ', ' ', ' ', 0, 'NET', 'Y');COMMIT;