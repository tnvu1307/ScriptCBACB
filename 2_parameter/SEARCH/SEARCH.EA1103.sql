SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('EA1103','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('EA1103', 'Giải tỏa chứng khoán(Escrow)(Giao dịch 1103)', 'Unblock stocks (Escrow)(1103)', 'select *
from (
    select e.* , se.emkqtty maxqtty
    from ESCROW e, semast se
    where e.sseacctno = se.acctno
        and e.deltd <> ''Y'' and e.sestatus in (''PC'',''BC'')
        and e.blockedqtty > 0
        and not EXISTS (select * from tllog tl, tllogfld tf
                        where tl.txdate = tf.txdate and tl.txnum = tf.txnum
                            and tltxcd  = ''1103'' and tl.txstatus = ''4'' and tl.deltd <> ''Y''
                            and tf.fldcd = ''01'' and tf.cvalue = e.escrowid
                            )
    order by e.createddt desc
) where 0=0', 'EA1103', NULL, NULL, '1103', NULL, 5000, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;