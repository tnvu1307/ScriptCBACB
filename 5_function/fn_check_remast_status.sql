SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_remast_status( pv_reacctno IN VARCHAR2)
--13/03/2018: Check trang thai cua Bieu hoa hong
--Neu Pass tra ve True, neu Faild tra ve False
    RETURN varchar2 IS
    v_count_active  number;
    v_count_close   number;
    v_Result        varchar2(10);
BEGIN
    select count(*) into v_count_active
    from remast re
    where re.acctno = pv_reacctno
        and status = 'A';
    
    select count(*) into v_count_close
    from remast re
    where re.acctno = pv_reacctno
        and status = 'C';
    
    if v_count_active = 0 and v_count_close > 0 then
        v_Result := 'False';
    else
        v_Result := 'True';
    end if;
    
    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 'False';
END;
 
 
/
