SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_crbbankrequest(pv_status In VARCHAR2 )
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(10);
BEGIN
     IF pv_status='Y'
        THEN
            V_RESULT := 'False';
        ELSE
            V_RESULT := 'True';
        END IF;
    RETURN V_RESULT;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 'False';
END;
/
