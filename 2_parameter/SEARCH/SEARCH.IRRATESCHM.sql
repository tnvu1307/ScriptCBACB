SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('IRRATESCHM','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('IRRATESCHM', 'Biểu lãi suất', 'Interest table', 'SELECT SCHD.AUTOID, SCHD.RATEID, SCHD.DELTA, SCHD.FRAMT, SCHD.TOAMT, SCHD.FRTERM, SCHD.TOTERM
FROM IRRATESCHM SCHD WHERE SCHD.RATEID=''<$KEYVAL>'' ORDER BY FRTERM, FRAMT', 'SA.IRRATESCHM', 'frmIRRATESCHM', '', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;