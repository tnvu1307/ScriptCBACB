SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_aqtty_1400(P_CRPHYSAGREEID VARCHAR2, P_AQTTY VARCHAR2) return number is
  v_Result number;
  v_trade number;
begin
  select se.trade into v_trade
  from semast se, crphysagree cr
  where se.acctno = cr.acctno || cr.codeid
  and cr.crphysagreeid = P_CRPHYSAGREEID;
  if TO_NUMBER(NVL(P_AQTTY,0)) > v_trade then
      v_Result := -1;
  else
      v_Result := 0;
  end if;
  return(v_Result);
EXCEPTION
    WHEN OTHERS THEN
        return -1;
end fn_check_aqtty_1400;
/
