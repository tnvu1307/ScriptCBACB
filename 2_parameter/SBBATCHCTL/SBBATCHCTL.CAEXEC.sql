SET DEFINE OFF;DELETE FROM SBBATCHCTL WHERE 1 = 1 AND NVL(BCHMDL,'NULL') = NVL('CAEXEC','NULL');Insert into SBBATCHCTL   (BCHSQN, APPTYPE, BCHMDL, BCHTITLE, RUNAT, ACTION, RPTPRINT, TLBCHNAME, MSG, BKP, BKPSQL, RSTSQL, ROWPERPAGE, RUNMOD, STATUS) Values   ('4011', 'CA', 'CAEXEC', 'Tự động thực hiện cho sự kiện quyền đến ngày thực hiện', 'BOD', ' ', 'N', 'CAEX', 'Tự động thực hiện cho sự kiện quyền đến ngày thực hiện', ' ', ' ', ' ', 0, 'NET', 'Y');COMMIT;