SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('OTCODMAST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('OTCODMAST', 'Hợp đồng mua bán OTC', 'OTC buy sell contract', 'SELECT OT.* , NVL(CB.BANKNAME,'''') SBANKNAME, a1.<@CDCONTENT> ddstatus_desc, a2.<@CDCONTENT> sestatus_desc,
    (CASE WHEN OT.STATUS IN (''A'',''P'') THEN ''Y'' ELSE ''N'' END) EDITALLOW,
    (CASE WHEN OT.STATUS IN (''P'') THEN ''Y'' ELSE ''N'' END) APRALLOW,
    (CASE WHEN OT.STATUS IN (''A'',''P'') THEN ''Y'' ELSE ''N'' END) AS DELALLOW
FROM OTCODMAST OT
    LEFT JOIN CRBBANKLIST CB ON OT.SBANKID = CB.CITAD
    left join (select RQ.REQID,RQ.REQCODE, RQ.REQTXNUM,  (CASE WHEN RQ.STATUS IN (''P'',''C'',''R'') THEN RQ.STATUS ELSE ''A'' END) STATUS
                from vw_crbtxreq_all rq where reqcode in (''PAYMENT2211_OUT'',''PAYMENT2211_IN'')
              ) rq on ot.trfreqid = rq.reqtxnum,
    (select * from allcode where cdname=''SUBSTATUS'' and cdtype =''EA'') a1,
    (select * from allcode where cdname=''SUBSTATUS'' and cdtype =''EA'') a2
WHERE OT.DELTD <> ''Y''
    and ot.ddstatus||nvl(rq.status,''C'') = a1.cdval
    --and (case when ot.bcustid is null then ''CC'' else ot.ddstatus||nvl(rq.status,''C'') end) = a1.cdval
    and ot.sestatus = a2.cdval', 'OTCODMAST', 'frmOTCODMAST', '', '', NULL, 5000, 'Y', 1, '', 'Y', 'T', '', 'N', '');COMMIT;