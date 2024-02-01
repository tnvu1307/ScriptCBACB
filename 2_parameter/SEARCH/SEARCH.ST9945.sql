SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ST9945','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ST9945', 'Tra cứu FileAct thông báo từ VSD (CSV)', 'Manage notification messages from VSD (CSV)', 'SELECT DA.*,A.CDCONTENT PARTYPE
FROM
(
    SELECT FILENAME,NVL(VSDID,REQID) VSDID,CSVFILENAME,TXDATE,TIMECREATED,TIMEPROCESS,(CASE WHEN VSDID IS NOT NULL THEN ''Y'' ELSE ''N'' END) AUTO
    FROM VSD_PARCONTENT_LOG v,
    (
        select max(to_date(decode(varname,''CURRDATE'',varvalue,''01/01/1900''),''DD/MM/RRRR'')) CURRDATE, max(decode(varname,''STPBKDAY'',to_number(varvalue),0)) STPBKDAY
        from sysvar where varname in (''CURRDATE'',''STPBKDAY'') and grname=''SYSTEM''
    ) sy
    WHERE sy.currdate - v.txdate <= sy.stpbkday
    UNION ALL
    SELECT FILENAME,NVL(VSDID,REQID) VSDID,CSVFILENAME,TXDATE,TIMECREATED,TIMEPROCESS,(CASE WHEN VSDID IS NOT NULL THEN ''Y'' ELSE ''N'' END) AUTO
    FROM VSD_PARCONTENT_LOG_HIST v,
    (
        select max(to_date(decode(varname,''CURRDATE'',varvalue,''01/01/1900''),''DD/MM/RRRR'')) CURRDATE, max(decode(varname,''STPBKDAY'',to_number(varvalue),0)) STPBKDAY
        from sysvar where varname in (''CURRDATE'',''STPBKDAY'') and grname=''SYSTEM''
    ) sy
    WHERE sy.currdate - v.txdate <= sy.stpbkday
)DA, (select * from allcode where cdname = ''PARTYPE'' and cdtype = ''ST'' and cduser = ''Y'') A
WHERE DA.AUTO = A.CDVAL(+)
AND DA.FILENAME LIKE ''%<@KEYVALUE>%''', 'STMAST', 'frmMTCSV', 'TIMECREATED DESC,TIMEPROCESS DESC', NULL, 0, 5000, 'Y', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;