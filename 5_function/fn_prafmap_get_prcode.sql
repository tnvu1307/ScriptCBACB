SET DEFINE OFF;
CREATE OR REPLACE FUNCTION FN_PRAFMAP_GET_PRCODE( pv_afacctno IN VARCHAR2, pv_prcode in varchar2)
    RETURN VARCHAR2 IS
    v_Result  VARCHAR2(200);

BEGIN
    v_Result:=' ';
    FOR P IN (SELECT PRCODE FROM PRAFMAP WHERE afacctno=pv_afacctno and STATUS='A' and PRCODE<>pv_prcode) LOOP
        IF v_Result=' ' THEN
            v_Result:=  P.PRCODE;
        ELSE
            v_Result:=  v_Result||', '||P.PRCODE;
        END IF;
    END LOOP;

    RETURN v_Result;

EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
 
 
 
 
/
