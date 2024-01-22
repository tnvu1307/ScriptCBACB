SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_amount_8864_14( PV_PRICE IN NUMBER, PV_QTTY IN NUMBER, PV_PARVALUE NUMBER)
    RETURN NUMBER IS
    v_result number;
BEGIN
    if  PV_PARVALUE = 0 then
        v_result := PV_PRICE * PV_QTTY;
    else
        v_result := PV_PARVALUE;
    end if;
RETURN v_result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
