SET DEFINE OFF;
CREATE OR REPLACE function fn_get_INTEREST(pv_bondcode varchar2, pv_begindate varchar2, pv_paydate varchar2, pv_actpaydate varchar2)
  return number is
  v_interest_pri varchar2(3);
  v_interest_day number;
  v_interest_coupon number;
  v_result number := 0;
begin
  begin
     select sb.intcoupon, sb.interestdate, sb.principleinterest into v_interest_coupon, v_interest_day, v_interest_pri
     from sbsecurities sb where sb.codeid = pv_bondcode;

  if v_interest_pri = '001' then
    v_result := to_number(to_date(pv_paydate,'DD/MM/RRRR') - to_date(pv_begindate,'DD/MM/RRRR')) * v_interest_coupon/v_interest_day;
  elsif v_interest_pri = '002' then
    v_result := to_number(to_date(pv_actpaydate,'DD/MM/RRRR') - to_date(pv_begindate,'DD/MM/RRRR')) * v_interest_coupon/v_interest_day;
  end if;

  exception when others then v_result := 0;
  end;
  return round(nvl(v_result,0),4);
end fn_get_INTEREST;
/
