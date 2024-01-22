SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getbaldefovd_released_depofee (
        p_afacctno IN VARCHAR2)
RETURN NUMBER
  IS
    l_BALDEFAVL NUMBER(20,2);
    l_cimastcheck_arr txpks_check.ddmastcheck_arrtype;
BEGIN
     dbms_output.put_line('p_afacctno:' || p_afacctno);
     l_CIMASTcheck_arr := txpks_check.fn_DDMASTcheck(p_afacctno,'DDMAST','ACCTNO');
     l_BALDEFAVL := l_CIMASTcheck_arr(0).balance;
     RETURN l_BALDEFAVL;
EXCEPTION WHEN others THEN
    --plog.error(dbms_utility.format_error_backtrace);
    dbms_output.put_line(' Err:' || dbms_utility.format_error_backtrace);
    return 0;
END;
/
