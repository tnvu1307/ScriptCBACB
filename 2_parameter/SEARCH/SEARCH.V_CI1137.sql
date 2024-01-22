SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('V_CI1137','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('V_CI1137', 'Danh sách import giao dịch hoàn thuế cho khách hàng (1137)', 'Import transaction refund tax (1137)', '
SELECT TB.AUTOID , TB.CUSTODYCD,TB.ACCTNO , CF.FULLNAME CUSTNAME, CF.ADDRESS,
CF.IDDATE,CF.IDPLACE,TB.AMT,TB.REFNUM,TB.DES ,getbaldefovd(CI.AFACCTNO) BALANCE ,cf. idcode LICENSE,
(case when ci.corebank =''Y'' then 1 else 0 end) ISCOREBANK
FROM TBLCI1137 TB, CFMAST CF, AFMAST AF,CIMAST CI
WHERE TB.CUSTODYCD = CF.CUSTODYCD AND CF.CUSTID = AF.CUSTID AND CI.ACCTNO = AF.ACCTNO
AND TB.ACCTNO = AF.ACCTNO AND NVL(TB.DELTD,''0'') <> ''Y'' ', 'CIMAST', 'frmCIMAST', '', '1137', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;