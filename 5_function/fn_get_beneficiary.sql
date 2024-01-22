SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_get_beneficiary(FULLNAME VARCHAR2,BENEFICIARY VARCHAR2)
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(250);

BEGIN
    v_Result:= BENEFICIARY;
    /*00if BENEFICIARY is null then
        v_Result:= FULLNAME;
    else
        v_Result:= BENEFICIARY;
    end if;*/
    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
