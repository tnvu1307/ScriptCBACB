SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE2237','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE2237', 'Gửi hồ sơ giải tỏa cầm cố/tạm giữ lên VSD (2237)', 'View pending to Send release mortage/temporary (wait for 2237)', 'SELECT SE.AUTOID, SE.BUSDATE, SE.TXDATE, SE.AFACCTNO, SE.ACCTNO, CF.FULLNAME CUSTNAME, CF.CUSTODYCD, SB.SYMBOL, SB.PARVALUE,
    (SE.QTTY - (GREATEST(SE.SENDQTTY, 0) + SE.RELEASED)) QTTY, SB.CODEID, CF.ADDRESS, CF.IDCODE LICENSE, CF.MCUSTODYCD,
    SE.TLTXCD
FROM SEMORTAGE SE, AFMAST AF ,CFMAST CF, SBSECURITIES SB
WHERE SE.AFACCTNO = AF.ACCTNO
AND AF.CUSTID = CF.CUSTID
AND SE.TLTXCD IN (''2233'',''2239'')
AND SE.STATUS IN (''N'')
AND SE.DELTD = ''N''
AND SE.CODEID = SB.CODEID
AND SE.QTTY - (GREATEST(SE.SENDQTTY, 0) + SE.RELEASED) > 0', 'SEMAST', NULL, 'AUTOID DESC', '2237', 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;