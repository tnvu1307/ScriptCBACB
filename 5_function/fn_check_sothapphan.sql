SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_sothapphan(P_CCYCD VARCHAR2,P_NUMBER VARCHAR2) RETURN VARCHAR2 IS

BEGIN
    IF P_CCYCD = 'VND' THEN
        if isInt(P_NUMBER) = 0 then
            return '-1';
        end if;
    END IF;
    RETURN '0';
EXCEPTION WHEN OTHERS THEN
    RETURN '-1';
END fn_check_sothapphan;
/
