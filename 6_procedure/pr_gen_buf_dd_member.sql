SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_gen_buf_dd_member(p_ddacctno varchar2 ,p_memberid varchar2,p_holdbalance number,p_pendinghold number,p_pendingunhold number ,p_odamt number,p_totalhold number, p_totalunhold number)
  IS
  v_count number;
  V_ODAMT NUMBER;
pkgctx plog.log_ctx;
BEGIN
if p_memberid is null or p_memberid= '' then ---check p_memberid return de khoi ton cost xu ly
  return;
end if;
  v_count:=0;
  select count(*) into v_count from  buf_dd_member where ddacctno = p_ddacctno and memberid = p_memberid;

  if v_count=0 then

     insert into buf_dd_member
     select cf.custodycd, cf.fullname ,dd.afacctno,dd.acctno,sysdate,m.autoid,m.fullname,
             p_holdbalance,p_pendinghold,p_pendingunhold,dd.refcasaacct,dd.ccycd,p_odamt,cf.cifid,p_totalhold,p_totalunhold
     from cfmast cf, ddmast dd, (select * from FAMEMBERS where autoid =p_memberid) m
     where cf.custodycd = dd.custodycd and  dd.acctno = p_ddacctno;
  else

    update  buf_dd_member
    set holdbalance=holdbalance+p_holdbalance, pendinghold=pendinghold+p_pendinghold,pendingunhold=pendingunhold+p_pendingunhold,odamt =odamt + p_odamt,
        totalhold = totalhold + p_totalhold,totalunhold = totalunhold +p_totalunhold
    where ddacctno = p_ddacctno and memberid = p_memberid;
  end if;
EXCEPTION WHEN others THEN
    plog.error(pkgctx, sqlerrm || dbms_utility.format_error_backtrace );
    plog.setendsection(pkgctx, 'pr_gen_buf_dd_member');
END pr_gen_buf_dd_member;
/
