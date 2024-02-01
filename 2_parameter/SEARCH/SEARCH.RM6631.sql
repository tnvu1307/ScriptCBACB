SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RM6631','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RM6631', 'Danh sách tài khoản cần tra cứu thông tin từ NH', 'List of account inquiry from BANK', 'SELECT AF.ACTYPE, CF.CUSTODYCD, AF.ACCTNO, AF.BANKNAME BANKCODE, AF.BANKNAME, AF.BANKACCTNO, CI.BALANCE, CI.HOLDBALANCE,
       CI.BANKAVLBAL, CI.BANKBALANCE, CI.BANKAVLBAL HOLDAMOUNT,
       CF.FULLNAME, CF.ADDRESS, CF.IDTYPE, CF.IDCODE, CF.IDDATE, CF.IDPLACE, CF.CAREBY
FROM CFMAST CF, AFMAST AF, CIMAST CI
WHERE CF.CUSTID = AF.CUSTID
      AND AF.ACCTNO = CI.AFACCTNO
      AND AF.ALTERNATEACCT = ''Y''
      AND CI.BANKAVLBAL = 0
      AND AF.BANKNAME LIKE ''BIDV%''
      AND AF.STATUS IN (''A'')', 'RM6631', NULL, NULL, '6631', NULL, 1000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;