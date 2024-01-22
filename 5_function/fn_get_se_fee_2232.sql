SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_se_fee_2232( PV_FEETYPE IN VARCHAR2,pv_qtty IN NUMBER , pv_pavalue IN number)
    RETURN NUMBER IS
-- Purpose: Phi giao dich 2245
-- MODIFICATION HISTORY
-- Person      Date         Comments
-- ---------   ------       -------------------------------------------
-- NAMNT   09/09/2013     Created
    V_RESULT NUMBER;
    V_FEETYPE VARCHAR2(30);

BEGIN
V_FEETYPE:= REPLACE( PV_FEETYPE,'''','');

V_RESULT := 0;
IF V_FEETYPE ='0025' THEN
V_RESULT := 300000;
ELSIF V_FEETYPE ='0026' THEN
V_RESULT := 1000000;
end if;

IF V_FEETYPE ='1212' THEN

V_RESULT := CASE WHEN  pv_qtty*pv_pavalue*0.002 < 100000 THEN 100000  WHEN  pv_qtty*pv_pavalue*0.002 > 300000 THEN 300000 ELSE  pv_qtty*pv_pavalue*0.002  END   ;

END IF ;

RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
 
 
 
 
 
/
