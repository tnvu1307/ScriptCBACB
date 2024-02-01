SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RM6640','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RM6640', 'Tra cứu phong tỏa bổ xung (6640)', 'View block more money from the bank (6640)', 'SELECT BUF.CUSTODYCD, BUF.AFACCTNO, BUF.BAMT+BUF.ODAMT-CI.HOLDBALANCE AMT,
BUF.EXECBUYAMT, BUF.BAMT, BUF.ODAMT, CI.HOLDBALANCE, CI.HOLDMNLAMT, AF.ADVANCELINE
FROM BUF_CI_ACCOUNT BUF, AFMAST AF, CIMAST CI
WHERE BUF.AFACCTNO=AF.ACCTNO AND CI.AFACCTNO=AF.ACCTNO AND AF.COREBANK=''Y'' AND BUF.BAMT+BUF.ODAMT-CI.HOLDBALANCE>0 ', 'BANKINFO', NULL, NULL, '6640', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;