SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_8838_get_quoteprice( pv_amt number,pv_qtty number)
    RETURN NUMBER IS
    v_Result  NUMBER (20,10);

BEGIN
    v_Result:=pv_amt/pv_qtty;
   RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;

 
 
 
 
/
