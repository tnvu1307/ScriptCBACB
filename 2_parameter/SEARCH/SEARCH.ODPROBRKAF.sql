SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ODPROBRKAF','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ODPROBRKAF', 'Danh sách tiểu khoản', 'List of sub-account', 'SELECT RF.AUTOID, RF.REFAUTOID, RF.AFACCTNO, CF.FULLNAME, CF.CUSTODYCD, TYP.TYPENAME,RF.CREATEDDATE
FROM ODPROBRKAF RF, CFMAST CF, AFMAST AF, AFTYPE TYP
WHERE RF.REFAUTOID=<$KEYVAL> AND RF.AFACCTNO=AF.ACCTNO AND RF.deltd <> ''Y'' AND AF.CUSTID=CF.CUSTID AND AF.ACTYPE=TYP.ACTYPE
ORDER BY CF.CUSTODYCD, RF.AFACCTNO', 'SA.ODPROBRKAF', 'frmODPROBRKAF', NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;