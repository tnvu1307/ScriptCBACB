SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gen_reqkey
    RETURN NUMBER IS
    v_Result  NUMBER;
    
BEGIN
    
    v_Result:=to_char(systimestamp,'RRRRMMDDHH24MISSFF3');
    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN to_char(systimestamp,'RRRRMMDDHH24MISSFF3');
END;
/
