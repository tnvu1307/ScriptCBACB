SET DEFINE OFF;

DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3335','NULL');

Insert into SEARCH
   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT)
 Values
   ('CA3335', 'Tra cứu xác nhận danh sách người sở hữu chứng khoán lưu ký thực hiện quyền', 'Lookup confirmed list of holders of securities depository execution rights', 'SELECT CA.CAMASTID, A1.CDCONTENT CATYPE,CA.CODEID,SB.SYMBOL,A2.CDCONTENT CASTATUS, CA.REPORTDATE, CA.DESCRIPTION,
A3.CDCONTENT VSDSTATUS, CA.VSDID, A4.CDCONTENT MSGSTATUS, CSV.CSVFILENAME FILENAME, MT564.VSDMSGID
FROM VSD_MT564_INF  MT564, CAMAST CA, SBSECURITIES SB,
(
    SELECT * FROM VSD_PARCONTENT_LOG
    UNION ALL
    SELECT * FROM VSD_PARCONTENT_LOG_HIST
) CSV,
(SELECT * FROM ALLCODE WHERE CDNAME = ''CATYPE'')A1,
(SELECT * FROM ALLCODE WHERE CDNAME = ''CASTATUS'')A2,
(SELECT * FROM ALLCODE WHERE CDNAME = ''CAVSDSTS'')A3,
(SELECT * FROM ALLCODE WHERE CDNAME = ''VSDTXREQSTS'')A4
WHERE CA.VSDID = MT564.VSDREFERENCE
AND CA.VSDID = CSV.VSDID(+)
AND CA.CODEID = SB.CODEID
AND CA.CATYPE = A1.CDVAL(+)
AND CA.STATUS = A2.CDVAL(+)
AND CA.VSDSTATUS = A3.CDVAL(+)
AND MT564.MSGSTATUS = A4.CDVAL(+)
AND MT564.MSGSTATUS IN (''P'',''N'',''R'')
AND (CA.STATUS in (''A'',''N'',''S'',''V'',''M'') or (CA.CATYPE IN (''005'',''006'',''0022'') AND CA.STATUS NOT IN (''P'',''D'',''E'',''R'',''C'')))
--AND CA.STATUS in (''N'',''A'')
AND MT564.VSDPROMSG_VALUE = ''NEWM''
AND CA.DELTD <> ''Y''', 'CAMAST', NULL, 'CAMASTID DESC', '3335', 0, 5000, 'N', 30, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);
COMMIT;
