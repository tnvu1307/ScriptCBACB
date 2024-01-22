SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_GET_DFLIMIT_0021( pv_05 IN number,pv_06 IN NUMBER,pv_07 IN NUMBER)
    RETURN NUMBER IS
    v_Result  NUMBER;

BEGIN
     v_Result :=pv_07;
     IF(pv_07 < pv_06 and pv_07 < pv_05) then
         v_Result:=pv_05;
     else
         v_Result:=pv_07;
     end if;


    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
 
 
/
