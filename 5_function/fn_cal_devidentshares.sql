SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_cal_devidentshares (pv_typerate         IN VARCHAR2,
/* Formatted on 5-Nov-2014 17:06:09 (QP5 v5.126) */
                                pv_devidentrate     IN VARCHAR2,
                                pv_devidentshares   IN VARCHAR2)
    RETURN VARCHAR2
IS
    v_result   VARCHAR2 (30);
    v_multiply number;
    v_temp number(20,10);
BEGIN
    IF (pv_typerate = 'R')
    THEN
    begin
       v_temp :=to_number(pv_devidentrate);
       v_multiply:=100;
        WHILE (v_temp <1 and v_temp <> 0)
        LOOP
           v_temp := v_temp * 10;
           v_multiply:=v_multiply*10;
        END LOOP;

       v_result := to_char(v_multiply) ||'/'||TO_CHAR(v_temp)  ;
    end;
    ELSE
        v_result := pv_devidentshares;
    END IF;

    RETURN v_result;
EXCEPTION
    WHEN OTHERS
/*ADVICE(18): A WHEN OTHERS clause is used in the exception section
                  without any other specific handlers [201] */
    THEN
        plog.error (SQLERRM || dbms_utility.format_error_backtrace);
        RETURN 0;
END;
/*ADVICE(23): END of program unit, package or type is not labeled [408] */
/
