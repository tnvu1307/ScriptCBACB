SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('EA1104','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('EA1104', 'Giải tỏa tiền (GD 1104)', 'Unblock cash (Trans 1104)', 'select *
from (
    select e.*, NVL(DD.REFCASAACCT,'''') BBANKACCTNO_ESCROW, dd.holdbalance maxamt
    from ESCROW e
        LEFT JOIN (select rq.reqid,rq.reqcode, rq.reqtxnum,  rq.status status
                    from vw_crbtxreq_all rq
                    where reqcode in (''UNHOLD1104'') and rq.status = ''R''
                  ) rq on e.unholdreqid = rq.reqtxnum
         , ddmast dd
    where e.bddacctno_escrow = dd.acctno
        and e.deltd <> ''Y''
        and (e.ddstatus in (''B'') or (e.ddstatus = ''A'' and nvl(rq.status,''C'') = ''R''))
        and not EXISTS (select * from tllog tl, tllogfld tf
                        where tl.txdate = tf.txdate and tl.txnum = tf.txnum
                            and tltxcd  = ''1104'' and tl.txstatus = ''4'' and tl.deltd <> ''Y''
                            and tf.fldcd = ''01'' and tf.cvalue = e.escrowid
                            )
    order by e.createddt desc
) where 0=0', 'EA1104', '', '', '1104', NULL, 5000, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;