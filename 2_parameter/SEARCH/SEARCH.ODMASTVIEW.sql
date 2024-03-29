SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ODMASTVIEW','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ODMASTVIEW', 'Quan ly so lenh', 'Order management', 'SELECT * FROM V_ODMASTVIEW where
ACCTNO in(
SELECT ''<$AFACCTNO>'' ACCTNO FROM DUAL
UNION ALL
SELECT  ACCTNO FROM  AFMAST WHERE CUSTID=''<$CUSTID>''
UNION
SELECT  ACCTNO FROM CFAUTH WHERE CUSTID=''<$CUSTID>'' AND SUBSTR(LINKAUTH,4,2)IN (''YY'',''YN'',''NY'')
UNION
SELECT  ACCTNO FROM CFLINK WHERE CUSTID=''<$CUSTID>'' AND SUBSTR(LINKAUTH,4,2)IN (''YY'',''YN'',''NY''))', 'OD.ODMAST', 'frmODMASTVIEW', 'ORDERID DESC', NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;