SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gen_exerciseratio(pv_Codeid In VARCHAR2,pv_EXERCISERATIO In VARCHAR2)
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(20);
BEGIN
    IF pv_EXERCISERATIO <> '0' THEN
        v_Result:=pv_EXERCISERATIO;
    ELSE
        SELECT NVL(EXERCISERATIO,'') INTO v_Result
        FROM SBSECURITIES WHERE CODEID=pv_Codeid;
    END IF;
    RETURN v_Result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/
