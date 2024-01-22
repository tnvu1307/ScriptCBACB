SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE2211','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE2211', 'Danh sách các hợp đồng mua OTC chờ đi tiền(Giao dịch 2211)', 'List of OTC purchase contracts waiting for transfer (2211)', 'SELECT OT.* , NVL(CB.BANKNAME,'''') SBANKNAME , D.ACCTNO BDDACCTNO, ot.BBANKACCOUNT BBANKACCTNO, LEAST(D.BALANCE,OT.AMT) MAXAMT, a1.<@CDCONTENT> ddstatus_desc
FROM OTCODMAST OT
    LEFT JOIN CRBBANKLIST CB ON OT.SBANKID = CB.CITAD
    left join (select RQ.REQID,RQ.REQCODE, RQ.REQTXNUM,  (CASE WHEN RQ.STATUS IN (''P'',''C'',''R'') THEN RQ.STATUS ELSE ''A'' END) STATUS
                from vw_crbtxreq_all rq where reqcode in (''PAYMENT2211_OUT'',''PAYMENT2211_IN'')
              ) rq on ot.trfreqid = rq.reqtxnum,
    (select * from allcode where cdname=''SUBSTATUS'' and cdtype =''EA'') a1, DDMAST D
WHERE ot.bcustid = d.custid
    AND OT.DELTD <> ''Y''
    AND OT.DDSTATUS||NVL(RQ.STATUS,''C'') = A1.CDVAL
    and a1.cdval in (''PC'',''CR'')
    AND D.REFCASAACCT = OT.BBANKACCOUNT AND D.STATUS <> ''C''
    AND OT.ISTRFCASH=''Y''
    AND NOT EXISTS(SELECT * FROM TLLOG TL, tllogfld TF
                    WHERE TL.TXDATE = TF.TXDATE AND TL.TXNUM = TF.TXNUM AND TL.TLTXCD = ''2211''
                        AND TF.FLDCD = ''01'' AND TF.CVALUE = OT.OTCODID
                        and tl.txstatus = ''4''
                    )', 'OTCODMAST', 'frmOTCODMAST', '', '2211', NULL, 5000, 'Y', 1, 'NNNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;