SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OD8813','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OD8813', 'View trading allocation(wait for 8813)', 'View trading allocation(wait for 8813)', 'SELECT OD.ORDERID,OD.CODEID,SEC.SYMBOL,B.CUSTODYCD,OD.AFACCTNO,OD.SEACCTNO,OD.CIACCTNO,B.BSCA BORS,B.NORP,OD.NORK AORN,
OD.QUOTEPRICE EXPRICE, OD.ORDERQTTY EXQTTY, A.VOLUME QTTY,A.PRICE PRICE,A.ORDERNUMBER REFORDERID, A.REFCONFIRMNUMBER CONFIRM_NO,
OD.BRATIO,OD.CLEARDAY,OD.CLEARCD, B.CUSTODYCD || ''.'' || B.BSCA || ''.'' || SEC.SYMBOL || ''.'' || A.VOLUME || ''.'' || A.PRICE  DESCRIPTION,
CASE B.BSCA = ''B'' THEN A.PRICE*A.VOLUME ELSE 0 END DCRAMT, CASE B.BSCA = ''B'' THEN A.VOLUME ELSE 0 END DCRQTTY
FROM ODMAST OD,SBSECURITIES SEC,STCTRADEBOOK A,STCORDERBOOK B WHERE OD.ORDERID=B.ORDERID AND  A.ORDERNUMBER=B.ORDERNUMBER AND OD.CODEID=SEC.CODEID AND SEC.TRADEPLACE=''002''
MINUS
SELECT OD.ORDERID,OD.CODEID,SEC.SYMBOL,B.CUSTODYCD,OD.AFACCTNO,OD.SEACCTNO,OD.CIACCTNO,B.BSCA BORS,B.NORP,OD.NORK AORN,
OD.QUOTEPRICE EXPRICE, OD.ORDERQTTY EXQTTY, A.VOLUME QTTY,A.PRICE PRICE,A.ORDERNUMBER REFORDERID, A.REFCONFIRMNUMBER CONFIRM_NO,
OD.BRATIO,OD.CLEARDAY,OD.CLEARCD , B.CUSTODYCD || ''.'' || B.BSCA || ''.'' || SEC.SYMBOL || ''.'' || A.VOLUME || ''.'' || A.PRICE  DESCRIPTION
FROM ODMAST OD,SBSECURITIES SEC, STCTRADEBOOK A,STCORDERBOOK B,STCTRADEALLOCATION C  WHERE OD.ORDERID=B.ORDERID AND  A.ORDERNUMBER=B.ORDERNUMBER
AND A.REFCONFIRMNUMBER=C.REFCONFIRMNUMBER AND OD.CODEID=SEC.CODEID AND C.DELTD<>''Y'' AND SEC.TRADEPLACE=''002''', 'OD.ODMAST', '', '', '8813', 10, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;