SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('MR0009','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('MR0009', 'Theo dõi các khoản thanh toán T3 quá hạn', 'T3 overdue account', 'select * from (
select cf.custodycd, max(cf.fullname) fullname, af.acctno afacctno, max(aft.actype) actype, max(aft.typename) typename,
    max(cf.mobilesms) mobilesms, max(cf.email) email,
    sum(case when od.txdate = to_date(sys.varvalue,''DD/MM/RRRR'') then
        case when od.feeacr > 0 then
            od.matchamt + (od.remainqtty*od.quoteprice) + od.feeacr
        else (od.matchamt + (od.remainqtty*od.quoteprice)) * (1 + od.bratio / 100) end
    else 0 end) securedT0,
    sum(case when
             --to_date(sys.varvalue,''DD/MM/RRRR'') = getduedate(od.txdate, ''B'', ''000'', 1)
             od.txdate= (select sbdate from sbcurrdate where numday =-1 and sbtype =''B'')
             then
        od.matchamt + od.feeacr
    else 0 end) securedT1,
    sum(case when
             --to_date(sys.varvalue,''DD/MM/RRRR'') = getduedate(od.txdate, ''B'', ''000'', 2)
             od.txdate= (select sbdate from sbcurrdate where numday =-2 and sbtype =''B'')
             then
        od.matchamt + od.feeacr
    else 0 end) securedT2,
    sum(case when
             --to_date(sys.varvalue,''DD/MM/RRRR'') = getduedate(od.txdate, ''B'', ''000'', 3)
             od.txdate= (select sbdate from sbcurrdate where numday =-3 and sbtype =''B'')
             then
        od.matchamt + od.feeacr
    else 0 end) securedT3,
    nvl(max(ln.odamt),0) securedOver,
    sum(case when od.txdate = to_date(sys.varvalue,''DD/MM/RRRR'') then
            case when od.feeacr > 0 then
                od.matchamt + (od.remainqtty*od.quoteprice) + od.feeacr
            else (od.matchamt + (od.remainqtty*od.quoteprice)) * (1 + od.bratio / 100) end
        else od.matchamt + od.feeacr end) + nvl(max(ln.odamt),0)  totalsecured,
    max(af.mrcrlimitmax) mrcrlimitmax, nvl(max(sec.seass),0) seass, max(ci.balance + nvl(sec.avladvance,0)) balance,
    nvl(max(sec.marginrate),0) marginrate,
    sum(case when od.txdate= (select sbdate from sbcurrdate where numday =-3 and sbtype =''B'')  then
        od.matchamt + od.feeacr
    else 0 end) + nvl(max(ln.odamt),0) - max(ci.balance + nvl(sec.avladvance,0)) addamount,
    max(grp.grpname) grpname
from cfmast cf, afmast af, cimast ci, aftype aft, mrtype mrt, sysvar sys,
(select od.afacctno, od.txdate, nvl(sts.cleardate,fn_get_nextdate(od.txdate, aft.trfbuyext) ) cleardate,
        od.matchamt, sts.amt, od.remainqtty, od.quoteprice, od.feeacr, od.bratio
    from afmast af, aftype aft, odmast od,
    (select sts.orgorderid, sts.afacctno, sts.txdate, sts.cleardate, sts.amt
        from stschd sts
        where duetype = ''SM'' and sts.deltd <> ''Y'') sts
where af.acctno = od.afacctno and af.actype = aft.actype and od.orderid = sts.orgorderid(+)
) od,
(select trfacctno, sum(oprinnml+oprinovd) odamt from lnmast where ftype = ''AF'' group by trfacctno) ln,
buf_ci_account sec,
(select * from tlgroups where grptype = 2) grp
where cf.custid = af.custid and af.acctno = ci.acctno and af.actype = aft.actype
and aft.mrtype = mrt.actype and af.acctno = od.afacctno(+)
and sys.varname = ''CURRDATE'' and sys.grname = ''SYSTEM''
and af.acctno = ln.trfacctno(+) and af.acctno = sec.afacctno(+)
and (aft.istrfbuy = ''Y'' and mrt.mrtype = ''T''  and nvl(od.txdate,to_date(sys.varvalue,''DD/MM/RRRR'')) = to_date(sys.varvalue,''DD/MM/RRRR'')
    or od.txdate <> od.cleardate
    or (aft.istrfbuy = ''Y'' and mrt.mrtype = ''T'' and ln.odamt > 0))
and af.careby = grp.grpid(+)
group by cf.custodycd, af.acctno
having nvl(max(ln.odamt),0)  > 0
) where 0=0', 'MRTYPE', NULL, NULL, NULL, 0, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;