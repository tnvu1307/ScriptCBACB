SET DEFINE OFF;
CREATE OR REPLACE function fn_is_only_input_TDCN_or_HCCN (pv_tdcn in number,pv_hccn in number) return number
is  
begin
    if (pv_tdcn is not null and pv_hccn is not null) AND  (pv_tdcn <> 0 and pv_hccn <> 0) then               
        return -1;
    end if;       
    
    return 0;
end;
/
