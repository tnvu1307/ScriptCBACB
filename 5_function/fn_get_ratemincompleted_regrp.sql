SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_ratemincompleted_regrp (MININCOME in number,COMPLETEDCOME in number,RATEMINCOMPLETED in number) return number
is
v_Result number;
v_MININCOME number;
v_COMPLETEDCOME number;
v_RATEMINCOMPLETED number;
v_RATIO number;
begin
    v_Result := 0;
    v_MININCOME := to_number(MININCOME);
    v_COMPLETEDCOME := to_number(COMPLETEDCOME);
    v_RATEMINCOMPLETED := to_number(RATEMINCOMPLETED);


    --lay tham so cau hinh tu sysvar
    begin
            select varvalue  into v_RATIO
            from sysvar
            where grname = 'RE' and varname = 'RATEMINCOMPLETED_REGRP_RATIO';
    EXCEPTION
            WHEN NO_DATA_FOUND
                   THEN
                        v_RATIO:=2;
    end;

    if nvl(v_MININCOME,0)<>0 and nvl(v_COMPLETEDCOME,0)<>0   then
        v_Result := (nvl(v_MININCOME,0)+nvl(v_COMPLETEDCOME,0))*v_RATIO;
    else
        v_Result := nvl(v_RATEMINCOMPLETED,0);
    end if;

    RETURN nvl(v_Result,0);

exception when others then
       RETURN 0;
       dbms_output.put_line('Error');
end;
 
 
/
