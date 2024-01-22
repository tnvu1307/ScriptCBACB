SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_1101_blockamt( pv_AMT IN VARCHAR2,pv_BLOCKRATE IN VARCHAR2)
    RETURN NUMBER IS
    v_Result  NUMBER;

BEGIN

    v_Result:=to_number(nvl(pv_AMT,'0')) * to_number(nvl(pv_BLOCKRATE,'0')) / 100;
    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
