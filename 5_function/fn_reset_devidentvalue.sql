SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_RESET_DEVIDENTVALUE(pv_TYPERATE In VARCHAR2,pv_DEVIDENTVALUE IN VARCHAR2)
    RETURN NUMBER IS
    v_Result  NUMBER(20,10);

BEGIN
    if(pv_TYPERATE='V') THEN
    v_Result:=to_number(replace(pv_DEVIDENTVALUE,',',''));
    ELSE
    v_Result:=0;
    END IF;

    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
 
 
 
 
/
