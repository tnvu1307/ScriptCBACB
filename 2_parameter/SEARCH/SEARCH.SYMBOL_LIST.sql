SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SYMBOL_LIST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SYMBOL_LIST', 'Quản lý thông tin chứng khoán', 'Stocks management', 'SELECT sb.codeid , sb.symbol,i.fullname, i.en_fullname 
from  sbsecurities sb,ISSUERS i 
WHERE  sb.ISSUERID = i.ISSUERID', 'ISSUERS', 'frmISSUERS', NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;