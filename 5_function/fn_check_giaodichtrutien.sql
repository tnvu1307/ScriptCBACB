SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_giaodichtrutien(P_CURRENT_SURPLUS VARCHAR2,P_DEDUCT_MONEY VARCHAR2) RETURN VARCHAR2 IS
   convertCurrentSurplus number;
BEGIN
    convertCurrentSurplus:= TO_NUMBER(REPLACE(P_CURRENT_SURPLUS, '999999999.99'));
    IF convertCurrentSurplus < P_DEDUCT_MONEY THEN
        return '-1';
    END IF;
    RETURN '0';
EXCEPTION WHEN OTHERS THEN
    RETURN '-1';
END fn_check_giaodichtrutien;
/
