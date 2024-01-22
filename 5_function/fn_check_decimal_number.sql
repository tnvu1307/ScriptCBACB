SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_decimal_number(P_CCYCD VARCHAR2, P_NUMBER VARCHAR2) RETURN VARCHAR2 IS
BEGIN

    IF P_CCYCD = 'VND' THEN
        BEGIN
            -- Try to convert the string to a number
            DECLARE
                P_DECIMAL NUMBER;
            BEGIN
                P_DECIMAL := TO_NUMBER(P_NUMBER, '9999999999999999999.9999999999');
                RETURN '0';
            EXCEPTION
                WHEN OTHERS THEN
                    RETURN '-1'; -- Not a valid decimal number
            END;
        END;
    ELSE
        RETURN '0'; -- For other currencies, assume it's a valid number
    END IF;

    RETURN '0';
EXCEPTION
    WHEN OTHERS THEN
        RETURN '-1';
END fn_check_decimal_number;
/
