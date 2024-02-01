SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SE2215','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SE2215', 'Cập Nhật Trạng Thái Chuyển Tiền Mua OTC', 'Update Status Transfer of Money to Buy OTC', 'SELECT OT.* , NVL(CB.BANKNAME,'''') SBANKNAME , D.ACCTNO BDDACCTNO, ot.BBANKACCOUNT BBANKACCTNO, LEAST(D.BALANCE,OT.AMT) MAXAMT, a1.<@CDCONTENT> ddstatus_desc
FROM OTCODMAST OT
    LEFT JOIN CRBBANKLIST CB ON OT.SBANKID = CB.CITAD
    left join (select RQ.REQID,RQ.REQCODE, RQ.REQTXNUM,  (CASE WHEN RQ.STATUS IN (''P'',''C'',''R'') THEN RQ.STATUS ELSE ''A'' END) STATUS
                from vw_crbtxreq_all rq where reqcode in (''PAYMENT2215_OUT'',''PAYMENT2215_IN'')
              ) rq on ot.trfreqid = rq.reqtxnum,
    (select * from allcode where cdname=''SUBSTATUS'' and cdtype =''EA'') a1, DDMAST D
WHERE ot.bcustid = d.custid
    AND OT.DELTD <> ''Y''
    AND OT.DDSTATUS||NVL(RQ.STATUS,''C'') = A1.CDVAL
    and a1.cdval in (''PC'',''CR'')
    AND D.REFCASAACCT = OT.BBANKACCOUNT AND D.STATUS <> ''C''
    AND OT.ISTRFCASH=''Y''
    AND NOT EXISTS(SELECT * FROM TLLOG TL, tllogfld TF
                    WHERE TL.TXDATE = TF.TXDATE AND TL.TXNUM = TF.TXNUM AND TL.TLTXCD = ''2215''
                        AND TF.FLDCD = ''01'' AND TF.CVALUE = OT.OTCODID
                        and tl.txstatus = ''4''
                    )', 'OTCODMAST', 'frmOTCODMAST', NULL, '2215', NULL, 5000, 'Y', 30, 'NNNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;