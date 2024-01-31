SET DEFINE OFF;
CREATE OR REPLACE function fn_6688_check_postdate_less_than_or_equal_current_Date(pv_postdate in varchar2) return number
    is
    v_postdate date;
    v_currentDate date;
begin
    v_postdate := TO_DATE(pv_postdate,'DD/MM/YYYY');
    v_currentDate := GETCURRDATE;
    
    if v_postdate > v_currentDate
    then
        return -1;
    end if;
    
    return 0;
end;
/
