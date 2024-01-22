SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SPREVIEW','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SPREVIEW', 'Danh sách tổng hợp review tăng lương', 'Salary review', 'select c.*, cf.fullname, cf.custodycd from
(
select reacctno, tlname,max(amt) amt, max(feeamt) feeamt, max(avgnewfee) avgnewfee,max(luonght) cursalary,max(basicsalary) basicsalary,max(addnew) addnew , (max(basicsalary) +max(addnew)) newsalary
from (
select a.reacctno, nvl(tl.tlname,'''') tlname, sum(a.amt)amt, sum(a.feeamt) feeamt, trunc(sum(feenew)/6) avgNewFee,
cfl.COMPLETEDCOME luongHT, (cfl.COMPLETEDCOME- nvl(cfl.addsalary,0)) basicsalary,
case when (sum(a.feeamt)  > sa.fv and sum(a.feeamt)  <= sa.tv) then sa.av else 0 end addnew
from recflnk cfl, tlprofiles tl,
(select 20000000 fv,40000000 tv,1000000 av from dual union select 40000000 ,80000000,2000000 from dual ) sa,

(
select rea.reacctno,to_char(rea.txdate,''MM/RRRR'')mon, sum(rea.amt)amt, sum(rea.freeamt) feeamt
,sum(case when ret.AFSTATUS =''N''   then REA.freeamt else 0 end) feeNew
from  reaf_log rea, retype ret
where rea.txdate <= getcurrdate()
and rea.txdate >= ADD_MONTHS(getcurrdate(),-6)
and ret.actype = rea.reactype
group by rea.reacctno,to_char(rea.txdate,''MM/RRRR'')
) a
where a.reacctno = cfl.custid
    and cfl.tlid = tl.tlid(+)
    and cfl.status = ''A''
group by a.reacctno,nvl(tl.tlname,''''),cfl.COMPLETEDCOME,cfl.addsalary,a.feeamt,sa.fv, sa.av,sa.tv
) b
group by reacctno, tlname
) c , afmast af, cfmast cf
where af.acctno = c.reacctno
and cf.custid = af.custid', 'SPREVIEW', '', ' addnew desc', '0387', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;