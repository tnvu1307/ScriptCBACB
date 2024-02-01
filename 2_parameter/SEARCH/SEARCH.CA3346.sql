SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3346','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3346', 'Sự kiện chuyển đổi (Nhận CP mới)', 'Bond converting (receive new stock)', 'SELECT * FROM (SELECT MAX(A.AUTOID) AUTOID,A.CAMASTID, A.DESCRIPTION, B.SYMBOL, A.ACTIONDATE , A.RECEIVEDATE POSTINGDATE,
SUM(CHD.QTTY) QTTY, MAX(CD.<@CDCONTENT>) CATYPE, MAX(A.TOCODEID) CODEID,
MAX(B2.SYMBOL) SYMBOL_ORG, ''N'' ISCANCEL, A.ISINCODE,SUM(CHD.AMT) CASHAMT,
SUM(CASE WHEN A.CATYPE = ''023'' THEN CHD.TRADE-CHD.BALANCE ELSE CHD.BALANCE END) CONVERTED
FROM CAMAST A, SBSECURITIES B, CASCHD CHD ,ALLCODE CD, SBSECURITIES B2
WHERE A.TOCODEID = B.CODEID AND A.STATUS  IN (''I'',''G'',''H'')
     AND A.DELTD<>''Y'' AND A.CAMASTID = CHD.CAMASTID AND CHD.DELTD <> ''Y''
     AND (SELECT COUNT(1) FROM CASCHD WHERE CAMASTID = A.CAMASTID AND ISSE =''N'' AND QTTY>0 AND DELTD=''N'') > 0
     AND CD.CDNAME =''CATYPE'' AND CD.CDTYPE =''CA'' AND CD.CDVAL = A.CATYPE
     AND B2.CODEID=A.CODEID
     AND A.CATYPE IN (''017'',''023'',''020'')
     AND NOT EXISTS (SELECT * FROM TLLOG WHERE MSGACCT = A.CAMASTID AND TXSTATUS =''4'' AND TLTXCD =''3341'')
     GROUP BY  A.ISINCODE, A.CAMASTID, A.DESCRIPTION, B.SYMBOL, A.ACTIONDATE, A.RECEIVEDATE
     HAVING SUM(CHD.QTTY) <>0
) WHERE 0=0', 'CAMAST', NULL, 'AUTOID DESC', '3341', 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;