SET DEFINE OFF;
CREATE OR REPLACE function fn_get_actualpaydate(P_PAYMENTDATE varchar2) return varchar2 is
  v_Result date;
  l_count number;
begin
  select COUNT(sbcldr.holiday) into l_count
  from sbcldr
  where sbdate =  TO_DATE(P_PAYMENTDATE,systemnums.C_DATE_FORMAT)
  and  sbcldr.holiday  = 'Y';
  if l_count > 0 then
      select min(sbdate) into v_Result from sbcldr where sbdate > TO_DATE(P_PAYMENTDATE,systemnums.C_DATE_FORMAT) and holiday='N' and cldrtype='000';
  else
      v_Result := TO_DATE(P_PAYMENTDATE,systemnums.C_DATE_FORMAT);
  end if;
  return TO_CHAR(v_Result,systemnums.C_DATE_FORMAT);
exception
    when others then
      plog.error(sqlerrm || dbms_utility.format_error_backtrace);
      return TO_CHAR(getcurrdate + 99999,systemnums.C_DATE_FORMAT);
end fn_get_ACTUALPAYDATE;
/
