SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CFFABROKERAGE2','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CFFABROKERAGE2', 'Thông tin công ty chứng khoán 2', 'Brokerage company information', 'SELECT FAM.AUTOID,FAM.DEPOSITMEMBER,  FAM.SHORTNAME ,FAM.FULLNAME BRKNAME
FROM FAMEMBERS FAM
WHERE FAM.ROLES=''BRK''
AND FAM.ACTIVESTATUS = ''Y''
AND AUTOID NOT IN (SELECT BRKID FROM FABROKERAGE WHERE CUSTODYCD=''<@KEYVALUE>'')', 'FABROKERAGE', NULL, 'AUTOID', 'EXEC', NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;