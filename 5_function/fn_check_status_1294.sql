SET DEFINE OFF;
CREATE OR REPLACE function fn_check_status_1294(p_status varchar2) return number is
  v_Result number;
begin
  if p_status = 'C' then
     v_Result := -1;
  else
     v_Result := 0;
  end if;
  return(v_Result);
end fn_check_status_1294;

/
