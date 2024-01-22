SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_formatnumber (p_value NUMBER)
    RETURN NUMBER IS

    v_logsctx       varchar(100);
    v_logsbody      varchar(100);
    v_exception     varchar(100);
    v_value         NUMBER;
    v_txtReturn     varchar(100);
BEGIN
    
        
    v_value := coalesce(p_value,0);
    if mod(v_value,1) > 0 then 
        v_txtReturn := trim(to_char(v_value, systemnums.C_NUMBER_FORMAT));        
    else
        v_txtReturn := trim(to_char( v_value, systemnums.C_NUMBER_FORMAT));
    end if;

    return v_txtReturn;
    
EXCEPTION
   WHEN OTHERS THEN
    RETURN v_txtReturn;
END;
/
