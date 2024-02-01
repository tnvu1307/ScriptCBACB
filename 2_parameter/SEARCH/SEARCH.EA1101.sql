SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('EA1101','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('EA1101', 'Phong tỏa chứng khoán (GD 1101)', 'Block securities (Trans 1101)', 'select mst.*, GREATEST(LEAST(mst.qtty,mst.maxqtty),0) bqtty, mst.parvalue * GREATEST(LEAST(mst.qtty,mst.maxqtty),0) bamt
from (
    select e.* , afs.acctno||e.codeid seacctno, fn_get_semast_avl_withdraw(afs.acctno,e.codeid) maxqtty, sb.parvalue
    from ESCROW e, cfmast cfs, afmast afs, sbsecurities sb
    where e.scustid = cfs.custid
        and cfs.custid = afs.custid
        and e.deltd <> ''Y'' and e.sestatus in (''PC'',''AC'')
        and e.codeid = sb.codeid
        and not EXISTS (select * from tllog tl, tllogfld tf
                        where tl.txdate = tf.txdate and tl.txnum = tf.txnum
                            and tltxcd  = ''1101'' and tl.txstatus = ''4'' and tl.deltd <> ''Y''
                            and tf.fldcd = ''01'' and tf.cvalue = e.escrowid
                            )
    order by e.createddt desc
) mst where 0=0', 'EA1101', NULL, NULL, '1101', NULL, 5000, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;