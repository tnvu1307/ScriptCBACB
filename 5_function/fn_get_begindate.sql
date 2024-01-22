SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_BEGINDATE(p_bondcode varchar2) return varchar2 is
  v_Result date;
  v_count number;
begin
  select count(*) into v_count from BONDTYPEPAY a where a.bondcode = p_bondcode;
  if v_count = 0 then
      select se.issuedate into v_Result from sbsecurities se where se.codeid = p_bondcode;
  else
      select max(a.paymentdate) into v_Result from BONDTYPEPAY a where a.bondcode = p_bondcode;
  end if;
  return(TO_CHAR(v_Result,systemnums.C_DATE_FORMAT));
end fn_get_BEGINDATE;
/
