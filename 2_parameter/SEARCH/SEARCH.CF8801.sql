SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF8801','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF8801', 'Số lượng đóng/mở tài khoản theo tháng', 'Number of close/open account by month', 'SELECT monthyear, careby, refullname, grname,
    brid, brname, D_count,  M_count,
     month_2,  year_2
FROM (select to_char(txdate,''MM/RRRR'') monthyear, careby, refullname, grname,
    brid, brname, sum(D_count) D_count, sum(M_count) M_count,
    to_char(txdate,''MM'') month_2, to_char(txdate,''RRRR'') year_2
from
(
    SELECT tl.txdate, nvl(gru.grpname,'' '') careby, re.fullname refullname, re.grname,
        substr(cf.custid,1,4) brid, br.brname , count(msgacct) D_count, 0 M_count
    FROM vw_tllog_all tl, cfmast cf, tlgroups gru,
        (
            select re.afacctno, cf.fullname, gr.fullname grname
            from reaflnk re, retype ret, remast mst, cfmast cf, regrplnk reg, regrp gr
            where ret.rerole =''RM'' and re.reacctno = mst.acctno and mst.actype = ret.actype
                and mst.custid = cf.custid and re.status = ''A'' and re.clstxdate is null
                and reg.reacctno = mst.acctno and reg.status = ''A'' and reg.clstxdate is NULL
                and reg.refrecflnkid = gr.autoid
        ) RE, brgrp br
    WHERE tl.tltxcd = ''0059'' AND tl.deltd <> ''Y''
        AND cf.custid = tl.msgacct AND CF.custodycd IS NOT NULL
        and cf.careby = gru.grpid(+) and cf.custid = re.afacctno (+)
        and substr(cf.custid,1,4) = br.brid
    group by tl.txdate, nvl(gru.grpname,'' ''), re.fullname, re.grname,
        substr(cf.custid,1,4), br.brname
    union all
    SELECT tl.txdate, nvl(gru.grpname,'' '') careby, re.fullname refullname, re.grname,
        tl.brid brid, br.brname, 0 D_count, count( tl.custid)  M_count
    FROM
    (
        SELECT cf.careby, SUBSTR(cf.custid,1,4) brid, cf.opndate txdate , cf.custid
        FROM cfmast cf
        WHERE cf.custodycd IS NOT NULL and cf.custodycd is not null
        union all
        SELECT cf.careby, SUBSTR(cf.custid,1,4) brid, tl.txdate, tl.msgacct
        FROM vw_tllog_all tl, cfmast cf
        WHERE tl.tltxcd = ''0067'' and tl.deltd <> ''Y''
            AND cf.custid = tl.msgacct
            AND CF.custodycd IS NOT NULL
    ) tl,
    (
            select re.afacctno, cf.fullname, gr.fullname grname
            from reaflnk re, retype ret, remast mst, cfmast cf, regrplnk reg, regrp gr
            where ret.rerole =''RM'' and re.reacctno = mst.acctno and mst.actype = ret.actype
                and mst.custid = cf.custid and re.status = ''A'' and re.clstxdate is null
                and reg.reacctno = mst.acctno and reg.status = ''A'' and reg.clstxdate is NULL
                and reg.refrecflnkid = gr.autoid
    ) RE, brgrp br, tlgroups gru
    where tl.custid = re.afacctno (+)
        and tl.brid = br.brid and tl.careby = gru.grpid(+)
    group by tl.txdate, nvl(gru.grpname,'' '') , re.fullname , re.grname,
        tl.brid , br.brname
    order by txdate desc
)
group by to_char(txdate,''MM/RRRR''), careby, refullname, grname, brid, brname,
    to_char(txdate,''RRRR'') , to_char(txdate,''MM'')
order by to_char(txdate,''RRRR'') desc, to_char(txdate,''MM'') desc
) WHERE 0=0', 'CFMAST', '', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;