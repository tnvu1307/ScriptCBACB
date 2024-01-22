SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_begindate_allowedit(p_bondcode varchar2,p_begindate varchar2) return varchar2 is
  v_Result date;
  v_count number;
  v_begindate date;
begin
    if p_begindate is not null then return p_begindate;
    else
    begin
          select count(*) into v_count from BONDTYPEPAY a where a.bondcode = p_bondcode;
          if v_count = 0 then
              select se.issuedate into v_Result from sbsecurities se where se.codeid = p_bondcode;
          else
              select max(a.paymentdate) into v_Result from BONDTYPEPAY a where a.bondcode = p_bondcode;
          end if;
          return(TO_CHAR(v_Result,systemnums.C_DATE_FORMAT));
    end;
   end if;
end fn_get_begindate_allowedit;
/
