SET DEFINE OFF;
CREATE OR REPLACE function fn_check_qtty_1404(p_CRPHYSAGREEID varchar2, p_qtty number) return number is
  v_Result number;
  v_receiving number;
  v_acctno varchar2(30);
  v_qtty number;
begin
  select cr.acctno||cr.codeid into v_acctno from crphysagree cr where cr.crphysagreeid = p_CRPHYSAGREEID;
  select NVL(se.receiving,0) into v_receiving from semast se where se.acctno = v_acctno;
  if p_qtty > v_receiving then
     v_Result := -1;
  else
     v_Result := 0;
  end if;
  return(v_Result);
end fn_check_qtty_1404;
/
