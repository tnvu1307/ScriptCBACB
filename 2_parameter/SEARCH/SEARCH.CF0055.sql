SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF0055','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF0055', 'Điều chỉnh thông tin về quyền', 'Adjust authorize information(0055)', 'SELECT AUTOID, CFCUSTID, CUSTID, FULLNAME, ADDRESS, TELEPHONE,
       LICENSENO, VALDATE, EXPDATE, DELTD, LINKAUTH,
       SIGNATURE, ACCOUNTNAME, BANKACCOUNT, BANKNAME,
       SUBSTR(LINKAUTH,1,1) VIEWSCD,
       SUBSTR(LINKAUTH,2,1) RPTCD,
       SUBSTR(LINKAUTH,3,1) CASHCD,
       SUBSTR(LINKAUTH,4,1) BUYCD,
       SUBSTR(LINKAUTH,5,1) SELLCD,
       SUBSTR(LINKAUTH,6,1) SIGNCD,
       SUBSTR(LINKAUTH,7,1) TRANSFERCD,
       SUBSTR(LINKAUTH,8,1) RESERVER1CD,
       SUBSTR(LINKAUTH,9,1) RESERVER2CD,
       SUBSTR(LINKAUTH,10,1) RESERVER3CD,
       (CASE WHEN SUBSTR(LINKAUTH,1,1)=''Y'' THEN ''YES'' ELSE ''NO'' END)  VIEWS,
       (CASE WHEN SUBSTR(LINKAUTH,2,1)=''Y'' THEN ''YES'' ELSE ''NO'' END)  RPT,
       (CASE WHEN SUBSTR(LINKAUTH,3,1)=''Y'' THEN ''YES'' ELSE ''NO'' END)  CASH,
       (CASE WHEN SUBSTR(LINKAUTH,4,1)=''Y'' THEN ''YES'' ELSE ''NO'' END)  BUY,
       (CASE WHEN SUBSTR(LINKAUTH,5,1)=''Y'' THEN ''YES'' ELSE ''NO'' END)  SELL,
       (CASE WHEN SUBSTR(LINKAUTH,6,1)=''Y'' THEN ''YES'' ELSE ''NO'' END)  SIGN,
       (CASE WHEN SUBSTR(LINKAUTH,7,1)=''Y'' THEN ''YES'' ELSE ''NO'' END)  TRANSFER,
       (CASE WHEN SUBSTR(LINKAUTH,8,1)=''Y'' THEN ''YES'' ELSE ''NO'' END)  RESERVER1,
       (CASE WHEN SUBSTR(LINKAUTH,9,1)=''Y'' THEN ''YES'' ELSE ''NO'' END)  RESERVER2,
       (CASE WHEN SUBSTR(LINKAUTH,10,1)=''Y'' THEN ''YES'' ELSE ''NO'' END)  RESERVER3
FROM CFAUTH WHERE 0=0', 'CFAUTH', '', '', '0055', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;