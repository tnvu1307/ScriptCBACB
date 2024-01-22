SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('V_CI1141','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('V_CI1141', 'Danh sách import giao dịch nhận chuyển khoản tiền (1141)', 'Import transaction receive cash transfer (1141)', '
SELECT TB.AUTOID , TB.CUSTODYCD,TB.ACCTNO , CF.FULLNAME CUSTNAME, CF.ADDRESS,
CF.IDDATE,CF.IDPLACE,TB.BANKID , TB.BANKACCTNO,TB.GLMAST,TB.AMT,TB.REFNUM,TB.DES
FROM TBLCI1141 TB, CFMAST CF, AFMAST AF
WHERE TB.CUSTODYCD = CF.CUSTODYCD AND CF.CUSTID = AF.CUSTID
AND TB.ACCTNO = AF.ACCTNO AND NVL(TB.DELTD,''0'') <> ''Y'' AND TB.AUTOID NOT IN (SELECT REFKEY FROM TLLOGEXT WHERE TLTXCD=''1141'' AND DELTD=''N'' AND STATUS IN (''0'',''1'', ''3'',''4'') )', 'CIMAST', 'frmCIMAST', '', '1141', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;