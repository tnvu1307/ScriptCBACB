SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SEARCH_INF_DE','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SEARCH_INF_DE', 'Tra cứu File Act thông báo từ VSD (CSV)', 'Manage notification massages from VSD (CSV)', 'SELECT DE.*
FROM (
    SELECT FILENAME, VSDID, CSVFILENAME, TXDATE, TIMECREATED, TIMEPROCESS, AUTOID FROM VSD_PARCONTENT_LOG
    UNION ALL
    SELECT FILENAME, VSDID, CSVFILENAME, TXDATE, TIMECREATED, TIMEPROCESS, AUTOID FROM VSD_PARCONTENT_LOG_HIST
) DE
WHERE (DE.FILENAME LIKE ''%DE065%'' OR DE.FILENAME LIKE ''%DE013%'')
AND DE.VSDID IS NOT NULL', 'STMAST', 'frmMTCSV', 'TIMECREATED DESC, TIMEPROCESS DESC', '', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;