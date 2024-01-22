SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gen_settlementprice(pv_Codeid In VARCHAR2,pv_SETTLEMENTPRICE In VARCHAR2,pv_TYPERATE IN VARCHAR2)
    RETURN NUMBER IS
    v_Result  number;
BEGIN
    IF pv_TYPERATE = 'R' THEN
        v_Result:=0;
    ELSE
        IF pv_SETTLEMENTPRICE <> 0 THEN
            v_Result:=pv_SETTLEMENTPRICE;
        ELSE
            SELECT NVL(SETTLEMENTPRICE,0) INTO v_Result
            FROM SBSECURITIES WHERE CODEID=pv_Codeid;
        END IF;
    END IF;
    RETURN v_Result;
EXCEPTION
   WHEN OTHERS THEN
    RETURN 0;
END;
/
