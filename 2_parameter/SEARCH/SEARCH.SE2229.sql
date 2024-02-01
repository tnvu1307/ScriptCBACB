SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE2229','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE2229', 'Chuyển khoản chứng khoán nội bộ OTC (Giao dịch 2229)', 'View account transfer to other account(wait for 2229)', 'SELECT  SE.CODEID,SB.SYMBOL,CF.CUSTODYCD, CF.FULLNAME , CF.ADDRESS, CF.IDCODE , SE.AFACCTNO,SE.ACCTNO,SE.SHAREHOLDERSID, SE.TRADE,SE.BLOCKED ,SB.PARVALUE, 
OT.OTCODID, CF2.CUSTODYCD BCUSTODYCD, CF2.FULLNAME BFULLNAME, AF2.ACCTNO BAFACCTNO, OT.QTTY, OT.PRICE, AF2.ACCTNO||OT.CODEID BACCTNO
FROM SEMAST SE,SBSECURITIES SB,CFMAST CF, OTCODMAST OT, CFMAST CF2, AFMAST AF2
WHERE SE.CODEID = SB.CODEID 
AND OT.SCUSTID = CF.CUSTID AND OT.CODEID = SB.CODEID
AND OT.BCUSTID = CF2.CUSTID
AND CF2.CUSTID = AF2.CUSTID
AND SE.CUSTID = CF.CUSTID
AND OT.SESTATUS IN (''PC'',''BC'')', 'SEMAST', 'frmSEMAST', NULL, '2229', 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;