SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CI9007','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CI9007', 'Quản trị nguồn giải ngân ứng trước (1155)', 'AD drawdown source management  (1155)', 'SELECT AD.AUTOID, AD.ISMORTAGE, AD.STATUS, AD.DELTD, AD.ACCTNO, AD.TXDATE, AD.TXNUM, AD.REFADNO, AD.CLEARDT,
AD.AMT, AD.FEEAMT, AD.VATAMT, AD.BANKFEE, AD.PAIDAMT, AD.ADTYPE, AD.RRTYPE, AD.CUSTBANK, AD.CIACCTNO, AD.ODDATE,
AD.PAIDDATE, A1.CDCONTENT RRTYPENAME,
decode(AD.RRTYPE, ''O'', 1,0) CIDRAWNDOWN,
decode(AD.RRTYPE, ''B'', 1,0) BANKDRAWNDOWN,
decode(AD.RRTYPE, ''C'', 1,0) CMPDRAWNDOWN
FROM ADSCHD AD, ALLCODE A1
WHERE AD.RRTYPE = A1.CDVAL AND A1.CDNAME =''RRTYPE''
      AND A1.CDTYPE =''LN''', 'CI.CIMAST', NULL, NULL, '1155', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;