SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_getbalance (
        p_afacctno IN VARCHAR2)
RETURN NUMBER
  IS
    l_BALDEFAVL NUMBER(20,2);
    l_cimastcheck_arr txpks_check.ddmastcheck_arrtype;
BEGIN
     l_CIMASTcheck_arr := txpks_check.fn_ddMASTcheck(p_afacctno,'CIMAST','ACCTNO');
     l_BALDEFAVL := l_CIMASTcheck_arr(0).BALANCE;
RETURN l_BALDEFAVL;
EXCEPTION WHEN others THEN
    --
    return 0;
END;
/
