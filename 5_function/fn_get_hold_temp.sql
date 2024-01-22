SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_GET_HOLD_TEMP(pv_AUTOID In VARCHAR2)
    RETURN number IS
    v_Result  number;

BEGIN
   SELECT  nvl((qtty - hold_temp),0) into v_Result from escrow where autoid = pv_AUTOID;
  
    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/
