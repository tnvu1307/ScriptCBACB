SET DEFINE OFF;
CREATE OR REPLACE function fn_check1903(p_quantity number, p_custodycd varchar2, p_bondcode varchar2)
return number
is
v_Result number;
v_trade number;
begin
  select bo.trade into v_trade from BONDSEMAST bo where bo.custodycd = p_custodycd and bo.bondcode = p_bondcode;
  if p_quantity > v_trade then
    v_Result := -1;
  else
    v_Result := 0;
  end if;
  return(v_Result);
end fn_check1903;
/
