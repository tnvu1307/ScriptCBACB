SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('V_CI1138','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('V_CI1138', 'Danh sách import giao dịch giảm trừ phí cho khách hàng (1138)', 'Import transaction deduct fee (1138)', '
SELECT TB.AUTOID , TB.CUSTODYCD,TB.ACCTNO , CF.FULLNAME CUSTNAME, CF.ADDRESS,
CF.IDDATE,CF.IDPLACE,TB.AMT,TB.REFNUM,TB.DES ,getbaldefovd(CI.AFACCTNO) BALANCE ,cf. idcode LICENSE,
(case when ci.corebank =''Y'' then 1 else 0 end) ISCOREBANK
FROM TBLCI1138 TB, CFMAST CF, AFMAST AF,CIMAST CI
WHERE TB.CUSTODYCD = CF.CUSTODYCD AND CF.CUSTID = AF.CUSTID AND CI.ACCTNO = AF.ACCTNO
AND AF.ACCTNO NOT IN (SELECT MSGACCT FROM TLLOG WHERE TLTXCD =''1138'' )
AND TB.ACCTNO = AF.ACCTNO AND NVL(TB.DELTD,''0'') <> ''Y'' ', 'CIMAST', 'frmCIMAST', NULL, '1138', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;