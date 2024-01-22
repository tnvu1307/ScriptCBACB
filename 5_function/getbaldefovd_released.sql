SET DEFINE OFF;
CREATE OR REPLACE FUNCTION GETBALDEFOVD_RELEASED (
        p_afacctno IN VARCHAR2)
RETURN NUMBER
  IS
    l_BALDEFOVD NUMBER(20,2);
    l_ddmastcheck_arr txpks_check.ddmastcheck_arrtype;
BEGIN
     l_ddMASTcheck_arr := txpks_check.fn_ddMASTcheck(p_afacctno,'DDMAST','ACCTNO');
     l_BALDEFOVD := l_DDMASTcheck_arr(0).balance;
RETURN l_BALDEFOVD;
EXCEPTION WHEN others THEN
    --plog.error(dbms_utility.format_error_backtrace);
    return 0;
END;
/
