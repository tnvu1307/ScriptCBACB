SET DEFINE OFF;
CREATE OR REPLACE function fn_check_settlementDate_more_than_or_equal_current_date(pv_settlementDate in varchar2) return number
    is
    v_settlementDate date;
    v_currentDate date;
begin
    v_settlementDate := TO_DATE(pv_settlementDate,'DD/MM/RRRR');
    v_currentDate := GETCURRDATE;
    
    if v_settlementDate < v_currentDate
    then
        return -1;
    end if;
    
    return 0;
end;
/
