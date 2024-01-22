SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gen_exerciseprice(pv_Codeid In VARCHAR2,pv_EXERCISEPRICE In NUMBER)
    RETURN NUMBER IS
    v_Result  number;
BEGIN
    IF pv_EXERCISEPRICE <> 0 THEN
        v_Result:=pv_EXERCISEPRICE;
    ELSE
        SELECT NVL(EXERCISEPRICE,0) INTO v_Result
        FROM SBSECURITIES WHERE CODEID=pv_Codeid;
    END IF;
    RETURN v_Result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
