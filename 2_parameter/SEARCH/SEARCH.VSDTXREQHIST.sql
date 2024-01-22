SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('VSDTXREQHIST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('VSDTXREQHIST', 'Tra cứu lịch sử thông tin chi tiết điện gửi VSD', 'Manage history of request messages sent to VSD', 'SELECT TO_CHAR(REQ.REQID) REQID, REQ.OBJNAME, SUBSTR(REQ.TRFCODE,1,3)TRFCODE, REQ.OBJKEY, TO_DATE(REQ.TXDATE,''DD/MM/RRRR'')TXDATE,
    CASE WHEN REQ.MSGACCT IN (SELECT CUSTODYCD FROM CFMAST WHERE CUSTODYCD = REQ.MSGACCT) THEN REQ.MSGACCT
         ELSE
            CASE WHEN REQ.AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE ACCTNO = REQ.AFACCTNO)
                THEN (SELECT CF.CUSTODYCD FROM CFMAST CF,AFMAST AF WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = REQ.AFACCTNO)
                 WHEN REQ.MSGACCT IN (SELECT CF.CUSTID FROM CFMAST CF WHERE CF.CUSTID = REQ.MSGACCT)
                THEN (SELECT CF.CUSTODYCD FROM CFMAST CF WHERE CF.CUSTID = REQ.MSGACCT)
            ELSE REQ.MSGACCT END
    END MSGACCT,
    DECODE(TRF.TYPE, ''INF'', TRF.DESCRIPTION, CODE.CDCONTENT || (CASE WHEN REQ.OBJNAME IN (''9999'',''1509'',''1515'',''3335'') THEN '' - '' || REQD.OCVAL ELSE '''' END)) NOTES,
    REQ.AFACCTNO, A5.<@CDCONTENT> MSGSTATUS, A5.CDVAL,
    REQ.VSD_ERR_MSG||'' ''||REQ.BOPROCESS_ERR VSD_ERR_MSG,
    TO_CHAR(REQ.CREATEDATE,''HH24:MI:SS'') CREATEDATE,
    REQ.TLID, TL.TLNAME, '''' AUTOCONF
FROM VSDTXREQHIST REQ, TLPROFILES TL,
(SELECT TRFCODE, DESCRIPTION CDCONTENT, EN_DESCRIPTION EN_CDCONTENT, TLTXCD FROM VSDTRFCODE) CODE,
(SELECT * FROM VSDTXREQDTLHIST WHERE FLDNAME IN (''REPORTID'',''RPTID''))REQD,
(
    SELECT MAX(TO_DATE(DECODE(VARNAME,''CURRDATE'',VARVALUE,''01/01/1900''),''DD/MM/RRRR'')) CURRDATE, MAX(DECODE(VARNAME,''STPBKDAY'',TO_NUMBER(VARVALUE),0)) STPBKDAY
    FROM SYSVAR WHERE VARNAME IN (''CURRDATE'',''STPBKDAY'') AND GRNAME=''SYSTEM''
) SY,
(
    SELECT DESCRIPTION, TRFCODE, TYPE, DECODE(TYPE,''INF'',TYPE,TLTXCD) OBJNAME
    FROM VSDTRFCODE
) TRF,
(SELECT * FROM ALLCODE WHERE CDTYPE = ''SA'' AND CDNAME = ''VSDTXREQSTS'') A5
WHERE REQ.TRFCODE = CODE.TRFCODE
AND REQ.OBJNAME = CODE.TLTXCD
AND REQ.MSGSTATUS = A5.CDVAL(+)
AND REQ.TLID=TL.TLID(+)
AND REQ.REQID = REQD.REQID(+)
AND SY.CURRDATE - REQ.TXDATE <= SY.STPBKDAY
AND REQ.TRFCODE = TRF.TRFCODE(+)
AND NVL(REQ.OBJNAME,''INF'') = TRF.OBJNAME (+)', 'VSDTXREQHIST', 'frmVSDTXREQHIST', 'TXDATE DESC,REQID DESC', '', NULL, 5000, 'Y', 1, '', 'Y', 'T', '', 'N', '');COMMIT;