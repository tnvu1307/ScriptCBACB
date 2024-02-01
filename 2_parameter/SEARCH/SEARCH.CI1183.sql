SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CI1183','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CI1183', 'Thu phí lưu ký đến hạn tiểu khoản NH', 'Collect maturity depository fee for bank sub-account', 'SELECT TYP.TYPENAME, CF.CUSTODYCD, CF.CUSTID, CF.FULLNAME, MST.AFACCTNO, AF.BANKACCTNO, AF.BANKNAME, MST.TODATE, MST.AVL
FROM AFMAST AF, CFMAST CF, AFTYPE TYP,
(SELECT AFACCTNO, TODATE, SUM(NMLAMT)-SUM(PAIDAMT)-SUM(FLOATAMT) AVL FROM CIFEESCHD WHERE DELTD<>''Y'' GROUP BY AFACCTNO, TODATE) MST
WHERE MST.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID AND AF.ACTYPE=TYP.ACTYPE AND TYP.COREBANK=''Y'' AND MST.AVL>0', 'BANKINFO', 'CI1183', 'CUSTODYCD, AFACCTNO, TODATE', '1183', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;