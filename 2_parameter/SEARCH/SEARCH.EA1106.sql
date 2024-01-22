SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('EA1106','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('EA1106', 'Thanh toán tiền (GD 1106)', 'Settle cash (Trans 1106)', 'select mst.*, GREATEST( LEAST(mst.amt,maxamt),0) EAAMT
from (
    select e.* , NVL(DE.REFCASAACCT,'''') BBANKACCTNO_ESCROW, NVL(CB.BANKNAME,'''') SBANKNAME, decode(e.CCYCD,''USD'',nvl(di.balance,0),nvl(de.balance,0)) maxamt
    from ESCROW e
        LEFT JOIN (select rq.reqid,rq.reqcode, rq.reqtxnum,  rq.status status
                    from vw_crbtxreq_all rq
                    where reqcode in (''HOLD1102'')
                  ) rq on e.unholdreqid = rq.reqtxnum
        LEFT JOIN (select rq.reqid,rq.reqcode, rq.reqtxnum,  rq.status status
                    from vw_crbtxreq_all rq
                    where reqcode in (''PAYMENT1106'') and status = ''R''
                  ) rq1106 on e.trfreqid = rq1106.reqtxnum
         LEFT join ddmast de on e.bddacctno_escrow = de.acctno
         LEFT join ddmast di on e.bbankacctno_iica = di.refcasaacct and e.bcustodycd = di.custodycd and di.status = ''A''
         LEFT JOIN CRBBANKLIST CB ON E.SBANKID = CB.CITAD
    where  e.deltd <> ''Y''
        and (e.ddstatus in (''P'',''A'') or (e.ddstatus = ''B'' and nvl(rq.status,''C'') = ''C'') or (e.ddstatus = ''C'' and nvl(rq1106.status,''C'') = ''R''))
        and not EXISTS (select * from tllog tl, tllogfld tf
                        where tl.txdate = tf.txdate and tl.txnum = tf.txnum
                            and tltxcd  = ''1106'' and tl.txstatus = ''4'' and tl.deltd <> ''Y''
                            and tf.fldcd = ''01'' and tf.cvalue = e.escrowid
                            )
    order by e.createddt desc
) mst where 0=0', 'EA1106', '', '', '1106', NULL, 5000, 'N', 30, 'NNNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;