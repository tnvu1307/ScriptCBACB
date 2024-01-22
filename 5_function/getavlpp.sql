SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getavlpp (p_afacctno IN VARCHAR2)
RETURN NUMBER
  IS
    l_PP NUMBER(20,2);
    l_ddmastcheck_arr txpks_check.ddmastcheck_arrtype;
BEGIN
     l_DDMASTcheck_arr := txpks_check.fn_DDMASTcheck(p_afacctno,'DDMAST','ACCTNO');
     l_PP := l_DDMASTcheck_arr(0).pp;
    RETURN l_PP;
EXCEPTION WHEN others THEN
    return 0;
END;
/
