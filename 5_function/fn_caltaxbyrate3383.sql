SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_caltaxbyrate3383( pv_14 IN VARCHAR2,pv_13 IN VARCHAR2,pv_21 IN VARCHAR2)
    RETURN NUMBER IS
    v_Result  NUMBER;
   
    
BEGIN
    
    v_Result:=to_number(pv_14) * to_number(pv_13) * to_number(pv_21) /100;
    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
 
 
 
 
/
