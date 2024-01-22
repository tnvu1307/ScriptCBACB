SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_recorddate(p_ACTUALPAYDATE varchar2) return varchar2 is
  v_Result date;
  v_i number;
begin
  v_Result := TO_DATE(p_ACTUALPAYDATE,systemnums.C_DATE_FORMAT);
  for v_i IN 1..5
    loop
      v_Result :=  getprevworkingdate(v_Result);
      end loop;
  return TO_CHAR(v_Result,systemnums.C_DATE_FORMAT);
  exception
    when others then
      plog.error(sqlerrm || dbms_utility.format_error_backtrace);
      return TO_CHAR(getcurrdate + 99999,systemnums.C_DATE_FORMAT);
end fn_get_RECORDDATE;
/
