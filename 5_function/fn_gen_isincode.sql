SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_gen_isincode(pv_Codeid In VARCHAR2, pv_BR in VARCHAR2)
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(250);
    v_isincode varchar2(50);
BEGIN
/*    v_isincode:=pv_BR;
    IF v_isincode is null then*/
        SELECT ISINCODE INTO v_Result
        FROM SBSECURITIES WHERE CODEID=pv_Codeid;
        RETURN v_Result;
/*    end if;
    RETURN v_isincode;
*/
EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/
