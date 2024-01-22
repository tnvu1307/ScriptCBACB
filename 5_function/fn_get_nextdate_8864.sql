SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_nextdate_8864(p_date varchar2, p_clearday number)
return varchar2
is
v_result varchar2(100);
begin
    v_result := to_char(getpdate_next(to_date(p_date,'dd/MM/RRRR'),p_clearday),systemnums.c_date_format);
    return v_result;
exception when others then
    return '01/01/1900';
end;
/
