SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('REAFLNK','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('REAFLNK', 'Tiểu khoản khách hàng thuộc môi giới/đại lý', 'Sub-account of broker/remiser', 'SELECT LNK.AUTOID,
LNK.REACCTNO, LNK.AFACCTNO, LNK.FRDATE, LNK.TODATE, A0.CDCONTENT STATUS, A1.CDCONTENT REROLE,
CF.FULLNAME REFULLNAME, CFCUST.FULLNAME CUSTNAME, TYP.TYPENAME
FROM REAFLNK LNK, RETYPE TYP, REMAST MST, CFMAST CF, CFMAST CFCUST, ALLCODE A0, ALLCODE A1
WHERE CF.CUSTID=MST.CUSTID AND CFCUST.CUSTID=LNK.AFACCTNO AND MST.ACCTNO=LNK.REACCTNO AND MST.ACTYPE = TYP.ACTYPE
AND A0.CDTYPE=''RE'' AND A0.CDNAME=''STATUS'' AND A0.CDVAL=LNK.STATUS
AND A1.CDTYPE=''RE'' AND A1.CDNAME=''REROLE'' AND A1.CDVAL=TYP.REROLE
AND LNK.REACCTNO=MST.ACCTNO AND MST.ACTYPE=TYP.ACTYPE AND LNK.REACCTNO=''<$KEYVAL>''', 'RE.REAFLNK', 'REAFLNK', NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;