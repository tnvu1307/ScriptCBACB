SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('ESCROW_EA','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('ESCROW_EA', 'Hợp đồng Escrow', 'Escrow contract', 'SELECT M.*, DE.REFCASAACCT BBANKACCTNO_ESCROW, ASE.<@CDCONTENT> SESTATUS_DESC, ACI.<@CDCONTENT> DDSTATUS_DESC,
        (case when M.SESTATUS = ''CC'' or M.CISTATUS = ''CC'' then ''N'' else ''Y'' end)EDITALLOW
FROM (
    SELECT E.*,  nvl(A1.<@CDCONTENT>,E.STATUS) STATUS_DESC, NVL(CB.BANKNAME,'''') SBANKNAME, NVL(CBB.BANKNAME,'''') BBANKNAME, E.DDSTATUS||NVL(RQ.STATUS,''C'') CISTATUS,
    --(CASE WHEN E.STATUS IN (''A'',''P'') THEN ''Y'' ELSE ''N'' END) EDITALLOW,
    (CASE WHEN E.STATUS IN (''P'') THEN ''Y'' ELSE ''N'' END) APRALLOW,
    (CASE WHEN E.STATUS IN (''A'',''P'') THEN ''Y'' ELSE ''N'' END) AS DELALLOW
    FROM (SELECT MST.*, DECODE(MST.DDSTATUS,''B'',MST.HOLDREQID, ''A'',MST.UNHOLDREQID,MST.TRFREQID) BANKREQID
            FROM ESCROW MST
            WHERE MST.DELTD <> ''Y''
        ) E
        LEFT JOIN
        (SELECT RQ.REQID,RQ.REQCODE, RQ.REQTXNUM,  (CASE WHEN RQ.STATUS IN (''P'',''C'',''R'') THEN RQ.STATUS ELSE ''A'' END) STATUS
            FROM VW_CRBTXREQ_ALL RQ
            WHERE REQCODE IN (''HOLD1102'',''UNHOLD1104'',''PAYMENT1106'') AND STATUS <> ''C''
        ) RQ ON E.BANKREQID =  RQ.REQTXNUM
        LEFT JOIN CRBBANKLIST CB ON E.SBANKID = CB.CITAD
        LEFT JOIN CRBBANKLIST CBB ON E.BBANKID = CBB.CITAD
        LEFT JOIN (SELECT * FROM ALLCODE WHERE CDNAME = ''ESCROW_STATUS'' AND CDTYPE = ''EA'') A1 on E.STATUS = A1.CDVAL
    ORDER BY E.CREATEDDT DESC
) M
--LEFT JOIN DDMAST DI ON M.BDDACCTNO_IICA = DI.ACCTNO
,
(SELECT * FROM ALLCODE WHERE CDNAME=''SUBSTATUS'' AND CDTYPE =''EA'') ASE,
(SELECT * FROM ALLCODE WHERE CDNAME=''SUBSTATUS'' AND CDTYPE =''EA'') ACI,
DDMAST DE
WHERE M.SESTATUS = ASE.CDVAL
    AND M.CISTATUS = ACI.CDVAL
    AND M.BDDACCTNO_ESCROW = DE.ACCTNO
     and M.SCUSTODYCD = ''<@KEYVALUE>''', 'ESCROW_EA', 'ESCROW_EA', NULL, NULL, NULL, 5000, 'Y', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;