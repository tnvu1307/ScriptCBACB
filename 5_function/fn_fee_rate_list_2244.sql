SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_FEE_RATE_LIST_2244( PV_TRTYPE IN VARCHAR2,  PV_FEERATELIST IN NUMBER)
    RETURN VARCHAR2 IS
-- Purpose: Phi giao dich 2244
-- MODIFICATION HISTORY
-- Person      Date         Comments
-- ---------   ------       -------------------------------------------
-- LONGNH   23/11/2014     Created
    V_RESULT NUMBER;
    PV_STRTRTYPE  VARCHAR2(30);
    v_feerate NUMBER;
BEGIN

PV_STRTRTYPE:= REPLACE( PV_TRTYPE,'''','');
V_RESULT := 0;

    if PV_STRTRTYPE='016' THEN

        V_RESULT := PV_FEERATELIST;
    ELSE
        V_RESULT := '';
    end if;

RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
 
 
 
 
/
