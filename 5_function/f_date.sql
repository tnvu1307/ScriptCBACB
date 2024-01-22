SET DEFINE OFF;
CREATE OR REPLACE FUNCTION F_DATE(V_DATE IN VARCHAR2) RETURN NUMBER IS
    V_DATE1 DATE;
BEGIN
    SELECT TO_DATE(V_DATE,'DD/MM/RRRR') INTO V_DATE1
    FROM DUAL;
        RETURN 1;
    EXCEPTION WHEN OTHERS THEN
        BEGIN
            SELECT TO_DATE(V_DATE,'DD/MM/RRRR hh24:mi:ss') INTO V_DATE1 FROM DUAL;
            RETURN 2;
        EXCEPTION WHEN OTHERS THEN
             RETURN 0;
        END;
END;
/
