SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CRBBANKTRFLIST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CRBBANKTRFLIST', 'Tra cứu nhanh thông tin ngân hàng', 'Bank information', 'SELECT CITAD BANKID , BANKCODE, BANKNAME, REGIONAL,REGIONAL CITY, CREATEDT, BRANCHNAME
 FROM CRBBANKLIST a WHERE 0=0', 'CFBANK', NULL, NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;