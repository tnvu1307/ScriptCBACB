SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('FEELNSCHD','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('FEELNSCHD', 'Lich tra lai vay margin', 'Margin interest payment schedule', 'SELECT DISTINCT MST.AUTOID, MST.DUENO, MST.DUEDATE, MST.ACCTNO, A0.CDCONTENT REFTYPE, A1.CDCONTENT DUESTS, MST.NML, MST.OVD, MST.PAID
FROM (SELECT * FROM LNSCHD WHERE ACCTNO=''<$KEYVAL>'' UNION ALL SELECT * FROM LNSCHDHIST WHERE ACCTNO=''<$KEYVAL>'') MST, ALLCODE A0, ALLCODE A1 WHERE A0.CDTYPE = ''LN'' AND A0.CDNAME = ''REFTYPE'' AND A0.CDVAL=MST.REFTYPE and A1.CDTYPE = ''LN'' AND A1.CDNAME = ''DUESTS'' AND A1.CDVAL=MST.DUESTS AND MST.ACCTNO=''<$KEYVAL>'' AND MST.REFTYPE = ''F'' ORDER BY MST.DUEDATE', 'LN.LNSCHD', 'frmLNSCHD', NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;