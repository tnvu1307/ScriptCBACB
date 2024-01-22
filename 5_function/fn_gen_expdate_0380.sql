SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gen_expdate_0380 (p_frdate in varchar2,p_daysfuture number) return VARCHAR2
is
v_daysfuture number;
v_Result date;
--DINHNB: ham nhap vao ngay va so ngay
-- tra ve ngay tuong lai
begin
    v_daysfuture:= p_daysfuture;
    if  v_daysfuture is null then
        v_daysfuture := 365;
    else
        select to_char(to_date(p_frdate,'DD/MM/RRRR') +v_daysfuture) INTO v_Result
        from dual;
    end if;
    v_Result := getbusinessdate(v_Result);
    RETURN v_Result;
exception when others then
       RETURN null;
end;
 
 
/
