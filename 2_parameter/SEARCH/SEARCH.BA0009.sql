SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('BA0009','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('BA0009', 'SKQ cho chứng khoán cầm cố', 'CA for mortgaged securities', 'select CA.CAMASTID,A1.CDCONTENT CATYPE,CA.CODEID,CA.TOSYMBOL,CA.SYMBOL,CA.KHQDATE,
CA.REPORTDATE,CA.ACTIONDATE,TO_CHAR(CA.TRADEDATE,''DD/MM/RRRR'') TRADEDATE,case when ca.deltd=''Y'' then ''Cancelled'' else A2.CDCONTENT end STATUS,
''N'' CHKSTATUS 
FROM v_camast_cancelled CA,(SELECT SYMBOL FROM VW_BA0001 GROUP BY SYMBOL) BA,ALLCODE A1, ALLCODE A2
WHERE CA.SYMBOL = BA.SYMBOL AND  A1.CDTYPE = ''CA''
AND NOT CA.DELTD=''Y''  
AND A1.CDNAME = ''CATYPE'' AND A1.CDVAL = CA.CATYPE
AND A2.CDTYPE = ''CA'' AND A2.CDNAME = ''CASTATUS''
AND CA.STATUS = A2.CDVAL', 'BONDTYPE', '', '', '3391', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;