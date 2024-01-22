SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE2252','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE2252', 'Tra cuu cac tai khoan rut tien', 'View account to withdraw', 'SELECT   SUBSTR(SEMAST.ACCTNO,1,4) || ''.'' || SUBSTR(SEMAST.ACCTNO,5,6) || ''.'' || SUBSTR(SEMAST.ACCTNO,11,6) ACCTNO, SYM.SYMBOL, SUBSTR(AFACCTNO,1,4) || ''.'' || SUBSTR(AFACCTNO,5,6) AFACCTNO,
SEMAST.MORTAGE  MORTAGE,SEMAST.CODEID,SYM.PARVALUE,SEINFO.BASICPRICE  PRICE,SEMAST.LASTDATE SELASTDATE,AF.LASTDATE AFLASTDATE,NVL(SEMAST.LASTDATE,AF.LASTDATE) LASTDATE,CF.CUSTODYCD,A1.CDCONTENT TRADEPLACE
FROM SEMAST,SBSECURITIES SYM,AFMAST AF,CFMAST CF,ALLCODE A1
, SECURITIES_INFO SEINFO WHERE SYM.CODEID=SEINFO.CODEID
AND A1.CDTYPE = ''SA'' AND A1.CDNAME = ''TRADEPLACE'' AND A1.CDVAL = SYM.TRADEPLACE 
AND CF.CUSTID =AF.CUSTID 
AND SYM.CODEID = SEMAST.CODEID
AND SEMAST.afacctno= AF.acctno
AND SEMAST.MORTAGE >0', 'SEMAST', '', '', '2252', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;