SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('EA1105','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('EA1105', 'Thanh toán chứng khoán (GD 1105)', 'Settle securities (Trans 1105)', 'select *
from (
    select e.* , se.trade maxqtty, e.bafacctno||e.codeid bseacctno
    from ESCROW e, semast se
    where e.sseacctno = se.acctno
        and e.deltd <> ''Y'' and e.sestatus in (''PC'',''AC'')
        --and se.trade > 0
        and not EXISTS (select * from tllog tl, tllogfld tf
                        where tl.txdate = tf.txdate and tl.txnum = tf.txnum
                            and tltxcd  = ''1105'' and tl.txstatus = ''4'' and tl.deltd <> ''Y''
                            and tf.fldcd = ''01'' and tf.cvalue = e.escrowid
                            )
    order by e.createddt desc
) where 0=0', 'EA1105', '', '', '1105', NULL, 5000, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;