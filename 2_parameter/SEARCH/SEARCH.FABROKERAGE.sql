SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('FABROKERAGE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('FABROKERAGE', 'Thông tin công ty chứng khoán theo số TKLK', 'Brokerage company information', 'select FAB.AUTOID, FAB.CUSTODYCD, FAM.FULLNAME BRKNAME, FAM.AUTOID BRKID from FABROKERAGE FAB, FAMEMBERS FAM
where FAB.BRKID=FAM.AUTOID and FAB.CUSTODYCD=''<@KEYVALUE>''', 'FA.FABROKERAGE', NULL, 'AUTOID', NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;