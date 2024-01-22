SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('EA1102','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('EA1102', 'Phong tỏa tiền (GD 1102)', 'Block cash (Trans 1102)', 'select *
from (
    select e.* , dd.refcasaacct BBANKACCTNO_ESCROW, dd.balance maxamt
    from ESCROW e
        LEFT JOIN (select rq.reqid,rq.reqcode, rq.reqtxnum,  rq.status status
                    from vw_crbtxreq_all rq
                    where reqcode in (''HOLD1102'') and rq.status = ''R''
                  ) rq on e.holdreqid = rq.reqtxnum
    , ddmast dd
    where e.bddacctno_escrow = dd.acctno
        and e.deltd <> ''Y''
        and (e.ddstatus in (''P'',''A'') or (e.ddstatus = ''B'' and nvl(rq.status,''C'') = ''R''))
        and not EXISTS (select * from tllog tl, tllogfld tf
                        where tl.txdate = tf.txdate and tl.txnum = tf.txnum
                            and tltxcd  = ''1102'' and tl.txstatus = ''4'' and tl.deltd <> ''Y''
                            and tf.fldcd = ''01'' and tf.cvalue = e.escrowid
                            )
    order by e.createddt desc
) where 0=0', 'EA1102', '', '', '1102', NULL, 5000, 'N', 30, 'NNNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;