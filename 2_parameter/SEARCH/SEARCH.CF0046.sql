SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF0046','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF0046', 'Tra cứu trạng thái tiểu khoản CK', 'View securities sub account status', '
SELECT CF.CUSTODYCD, AF.ACCTNO,AF.ACTYPE, CF.FULLNAME,SB.SYMBOL,SB.BASICPRICE,SE.TRADE,SE.RECEIVING,NVL(B.MATCHEDAMT,0) MATCHEDAMT,NVL(B.REMAINQTTY,0) REMAINQTTY
FROM SEMAST SE,AFMAST AF,CFMAST CF,SECURITIES_INFO SB,
 (SELECT MAX(OD.SEACCTNO) SEACCTNO,af.acctno,SB.SYMBOL, SUM (CASE WHEN OD.EXECTYPE IN (''NS'',''SS'') THEN REMAINQTTY ELSE 0 END) REMAINQTTY,
  SUM(CASE WHEN OD.EXECTYPE IN (''NB'',''BC'') THEN EXECQTTY ELSE 0 END) MATCHEDAMT
  FROM ODMAST OD ,AFMAST AF, ODTYPE TYP,SYSVAR SYS,SECURITIES_INFO SB
 WHERE SYS.VARNAME=''CURRDATE'' AND SYS.GRNAME=''SYSTEM'' AND OD.CODEID=SB.CODEID AND
 OD.ACTYPE=TYP.ACTYPE AND AF.ACCTNO=OD.AFACCTNO AND  OD.TXDATE= TO_DATE(SYS.VARVALUE, ''DD\MM\YYYY'') AND DELTD <>''Y''
 group by af.acctno,SB.SYMBOL) B
 WHERE AF.ACCTNO=SE.AFACCTNO AND AF.CUSTID=CF.CUSTID AND SE.CODEID=SB.CODEID AND  SE.ACCTNO=B.SEACCTNO (+)
 AND se.TRADE + SE.RECEIVING+NVL(B.MATCHEDAMT,0) +NVL(B.REMAINQTTY,0)>0', 'CFMAST', NULL, NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;