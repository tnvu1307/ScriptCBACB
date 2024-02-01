SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR8801','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR8801', 'Dư nợ Margin theo môi giới quản lý', 'Margin outstanding by careby', 'select typename, brid, brname, marginamt, marginovdamt,
    margin30, margin31, refullname, grpname
from
(
    select lnt.typename, br.brid, br.brname,
        trunc(sum(round(ln.prinnml)+round(ln.prinovd)),0) marginamt,
        trunc(sum(round(ln.prinovd)+round(nvl(ls.dueamt,0))),0) marginovdamt,
        trunc(sum(round(nvl(ls1.amt30,0))),0) margin30,
        trunc(sum(round(nvl(ls2.amt31,0))),0) margin31,
        re.refullname, re.grpname
    from lnmast ln, lntype lnt, afmast af, aftype aft, brgrp br,
        (
            select acctno, sum(nml+intdue) dueamt
            from lnschd, (select * from sysvar where varname = ''CURRDATE'' and grname = ''SYSTEM'') sy
            where reftype = ''P'' and overduedate = to_date(varvalue,''DD/MM/RRRR'')
            group by acctno
        ) ls,
        (
            select acctno, sum(nml) amt30
            from lnschd, (select * from sysvar where varname = ''CURRDATE'' and grname = ''SYSTEM'') sy
            where reftype = ''P'' and to_date(varvalue,''DD/MM/RRRR'') - rlsdate <= 30
                and overduedate > to_date(varvalue,''DD/MM/RRRR'') and nml <> 0
            group by acctno
        ) ls1,
        (
            select acctno, sum(nml) amt31
            from lnschd, (select * from sysvar where varname = ''CURRDATE'' and grname = ''SYSTEM'') sy
            where reftype = ''P'' and to_date(varvalue,''DD/MM/RRRR'')- rlsdate > 30
                and overduedate > to_date(varvalue,''DD/MM/RRRR'') and nml <> 0
            group by acctno
        ) ls2,
        (
            select re.afacctno, cf.fullname refullname, regrp.fullname grpname
            from reaflnk re, remast mst, retype ret, cfmast cf, regrplnk reg, regrp
            where re.deltd <> ''Y'' and re.status = ''A'' and re.clstxdate is null
                and re.reacctno = mst.acctno and mst.actype = ret.actype
                and ret.rerole = ''RM'' and mst.custid = cf.custid
                and mst.acctno = reg.reacctno and reg.clstxdate is NULL
                and reg.status = ''A'' and reg.deltd <> ''Y''
                and reg.refrecflnkid = regrp.autoid
        )re
    where ln.ftype = ''AF'' and ln.actype = lnt.actype
        and ln.acctno = ls.acctno(+) and ln.acctno = ls1.acctno(+)
        and ln.acctno = ls2.acctno(+) and ln.trfacctno = af.acctno
        and af.actype = aft.actype and aft.mnemonic = ''Margin''
        and substr(af.custid,1,4) = br.brid
        and af.custid = re.afacctno(+)
    group by lnt.typename, br.brid, br.brname,
        re.refullname, re.grpname
    having sum(round(ln.prinnml)+round(ln.prinovd)) <> 0 or
        sum(round(ln.prinovd)+round(nvl(ls.dueamt,0))) <> 0 or
        sum(round(nvl(ls1.amt30,0))) <> 0 or
        sum(round(nvl(ls2.amt31,0))) <> 0
)
where 0=0', 'MRTYPE', NULL, NULL, NULL, NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;