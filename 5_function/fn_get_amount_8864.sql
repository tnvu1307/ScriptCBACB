SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_amount_8864( PV_TRANT IN VARCHAR2,PV_PRICE IN NUMBER, PV_FEE IN NUMBER, PV_TAX IN NUMBER,PV_AMT IN NUMBER)
    RETURN NUMBER IS
    v_result number;
BEGIN
    if PV_AMT = 0 and PV_FEE <> 0 and PV_TAX <> 0 then
        if PV_TRANT = 'NB' then
            v_result := PV_PRICE + PV_FEE;
        else
            v_result := PV_PRICE - PV_FEE - PV_TAX;
        end if;
    else
        if PV_TRANT = 'NB' then
            v_result := PV_AMT ;--+ PV_FEE + PV_TAX;
        else
            v_result := PV_AMT ;--- PV_FEE - PV_TAX;
        end if;
    end if;
RETURN v_result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
