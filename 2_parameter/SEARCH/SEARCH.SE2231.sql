SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE2231','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE2231', 'Tra cứu các tài khoản hủy gửi hồ sơ lưu ký (2231)', 'View pending revert send depository (2231)', '
SELECT distinct FN_GET_LOCATION(CFMAST.BRID) LOCATION, ACTYPE,SUBSTR(SEMAST.ACCTNO,1,4) || ''.'' || SUBSTR(SEMAST.ACCTNO,5,6) || ''.'' || SUBSTR(SEMAST.ACCTNO,11,6) ACCTNO,
SYM.SYMBOL, SYM.PARVALUE, SEMAST.CODEID, SUBSTR(AFACCTNO,1,4) || ''.'' || SUBSTR(AFACCTNO,5,6) AFACCTNO,SUBSTR(CUSTODYCD,1,4) || ''.'' || SUBSTR(CUSTODYCD,5,6) CUSTODYCD, SEMAST.OPNDATE, CLSDATE, SEMAST.LASTDATE,
A1.CDCONTENT STATUS, A4.CDCONTENT TRADEPLACE, SEMAST.PSTATUS, A2.CDCONTENT IRTIED,
A3.CDCONTENT ICCFTIED, IRCD, COSTPRICE,SEDEPOSIT.DEPOSITQTTY SENDDEPOSIT,
SEDEPOSIT.depotrade,SEDEPOSIT.depoblock,SEDEPOSIT.typedepoblock ,
SEDEPOSIT.DEPOSITPRICE DEPOSITPRICE,SEDEPOSIT.DESCRIPTION DESCRIPTION,
SEDEPOSIT.AUTOID AUTOID, CFMAST.CUSTID, COSTDT,CFMAST.FULLNAME CUSTNAME,
CFMAST.ADDRESS  ADDRESS,CFMAST.IDCODE  LICENSE, SEDEPOSIT.senddepodate PDATE,
SEDEPOSIT.TXDATE
FROM SEMAST,CFMAST,SBSECURITIES SYM,
(SELECT * FROM SEDEPOSIT WHERE STATUS=''S'' AND DELTD <> ''Y'') SEDEPOSIT,
ALLCODE A1, ALLCODE A2, ALLCODE A3,ALLCODE A4
WHERE SEMAST.SENDDEPOSIT>0
AND A1.CDTYPE = ''SE'' AND A1.CDNAME = ''STATUS'' AND A1.CDVAL = SEMAST.STATUS
AND SEMAST.CUSTID=CFMAST.CUSTID
AND A2.CDTYPE = ''SY'' AND A2.CDNAME = ''YESNO''  AND A2.CDVAL = IRTIED
AND SYM.CODEID = SEMAST.CODEID
AND A3.CDTYPE = ''SY'' AND A3.CDNAME = ''YESNO''  AND A3.CDVAL = SEMAST.ICCFTIED
AND A4.CDTYPE = ''SE'' AND A4.CDNAME = ''TRADEPLACE''  AND A4.CDVAL = SYM.TRADEPLACE
AND SEDEPOSIT.ACCTNO=SEMAST.ACCTNO
', 'SEMAST', '', '', '2231', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;