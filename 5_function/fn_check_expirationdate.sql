SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_expirationdate(p_status varchar2, p_expirationdate varchar2) return VARCHAR2 is
  v_Result VARCHAR2(100);
  v_expirationdate date;
begin
    v_expirationdate := to_date(p_expirationdate,'dd/MM/RRRR');

  if p_status = 'Y' and v_expirationdate < getcurrdate then
     v_Result := 'False';
  else
     v_Result := 'True';
  end if;
  return v_Result;
end fn_check_expirationdate;
/
