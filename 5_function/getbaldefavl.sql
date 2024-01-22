SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getbaldefavl (
        p_afacctno IN VARCHAR2)
RETURN NUMBER
  IS
    l_BALANCE NUMBER(20,2);
    l_ddmastcheck_arr txpks_check.ddmastcheck_arrtype;
BEGIN
     l_BALANCE:=0;
     l_DDMASTcheck_arr := txpks_check.fn_DDMASTcheck(p_afacctno,'DDMAST','ACCTNO');
     l_BALANCE := nvl(l_DDMASTcheck_arr(0).BALANCE,0);
RETURN l_BALANCE;
EXCEPTION WHEN others THEN
    --plog.error(dbms_utility.format_error_backtrace);
    return 0;
END;
/
