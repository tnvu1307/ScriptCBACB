SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getbankbaldefovd (
        p_afacctno IN VARCHAR2)
RETURN NUMBER
  IS
    l_BALDEFOVD NUMBER(20,2);
    l_cimastcheck_arr txpks_check.ddmastcheck_arrtype;
BEGIN
     l_cimastcheck_arr := txpks_check.fn_DDMASTcheck(p_afacctno,'DDMAST','ACCTNO');
     l_BALDEFOVD := least(l_cimastcheck_arr(0).BALANCE,l_CIMASTcheck_arr(0).HOLDBALANCE);
RETURN l_BALDEFOVD;
EXCEPTION WHEN others THEN
    --og.error(dbms_utility.format_error_backtrace);
    return 0;
END;
/
