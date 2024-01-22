SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_gen_buf_se_member(p_custodycd varchar2,p_symbol varchar2 ,p_memberid varchar2,p_totalhold number, p_totalunhold number,p_unhold_no_broker number)
  IS
  v_count number;
  V_ODAMT NUMBER;
pkgctx plog.log_ctx;
BEGIN
if p_memberid is null or p_memberid= '' then ---check p_memberid return de khoi ton cost xu ly
  return;
end if;
  v_count:=0;
  select count(*) into v_count from  buf_se_member where custodycd = p_custodycd and symbol = p_symbol and members = p_memberid;

  if v_count=0 then
     plog.error('Case insert');
     insert into buf_se_member
     select p_custodycd, p_symbol,sysdate,p_memberid,p_totalhold,p_totalunhold,p_unhold_no_broker
     from dual;
  else
    plog.error('Case update');
    update  buf_se_member
    set totalhold = totalhold + p_totalhold,
        totalunhold = totalunhold + p_totalunhold
    where custodycd = p_custodycd and members = p_memberid and symbol = p_symbol;
  end if;
EXCEPTION WHEN others THEN
    plog.error(pkgctx, 'Error pr_gen_buf_se_member' || nvl(p_custodycd,'NULL') );
END pr_gen_buf_se_member;
/
