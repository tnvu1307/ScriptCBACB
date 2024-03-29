SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('VSDTXINFOHIST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('VSDTXINFOHIST', 'Tra cứu lịch sử điện thông báo từ VSD', 'Manage history of notification messages from VSD', 'SELECT L.AUTOID, L.SENDER, L.MSGTYPE, L.FUNCNAME, L.REFMSGID,
       L.REFERENCEID, L.FINFILENAME, TO_CHAR(L.TIMECREATED,''HH24:MI:SS'')TIMECREATED , L.TIMEPROCESS,
       L.STATUS, L.AUTOCONF, L.ERRDESC, L.SYMBOL, L.RECLAS, L.REQTTY,
       L.REFCUSTODYCD, L.RECCUSTODYCD, L.VSDEFFDATE , C.CDCONTENT DESCRIPTION, L.TIMECREATED DATECREATED,
       NVL(A1.CDCONTENT,L.STATUS) MSGSTATUS
FROM VSDTRFLOGHIST L, (SELECT TRFCODE, DESCRIPTION CDCONTENT, EN_DESCRIPTION EN_CDCONTENT, TYPE FROM VSDTRFCODE WHERE TYPE = ''INF'') C,
    (SELECT * FROM ALLCODE WHERE CDNAME LIKE  ''VSDTRFLOGSTS'' AND CDTYPE = ''ST'') A1,
    (
        SELECT MAX(TO_DATE(DECODE(VARNAME,''CURRDATE'',VARVALUE,''01/01/1900''),''DD/MM/RRRR'')) CURRDATE, MAX(DECODE(VARNAME,''STPBKDAY'',TO_NUMBER(VARVALUE),0)) STPBKDAY
        FROM SYSVAR
        WHERE VARNAME IN (''CURRDATE'',''STPBKDAY'')
        AND GRNAME=''SYSTEM''
    ) SY
WHERE  L.FUNCNAME = C.TRFCODE(+)
AND L.STATUS = A1.CDVAL(+)
AND L.FUNCNAME NOT LIKE ''%.ACK''
AND L.FUNCNAME NOT LIKE ''%.NAK''
AND  SY.CURRDATE - TRUNC(L.TIMECREATED) <= SY.STPBKDAY', 'TTDIENRHIST', 'frmVSDTXINFOHIST', ' DATECREATED DESC, TIMECREATED DESC', NULL, 0, 5000, 'Y', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;