SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getbaldefovd (
        p_afacctno IN VARCHAR2)
RETURN NUMBER
  IS
    l_BALDEFOVD NUMBER(20);
    l_ddmastcheck_arr txpks_check.ddmastcheck_arrtype;
BEGIN
     l_DDMASTcheck_arr := txpks_check.fn_DDMASTcheck(p_afacctno,'DDMAST','ACCTNO');
     l_BALDEFOVD := trunc(l_DDMASTcheck_arr(0).BALANCE);
RETURN NVL(l_BALDEFOVD, 0);
EXCEPTION WHEN others THEN
    --plog.error(dbms_utility.format_error_backtrace);
    return 0;
END;
/
