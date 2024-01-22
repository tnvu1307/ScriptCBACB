SET DEFINE OFF;
CREATE OR REPLACE FUNCTION GETBALDEFOVDCOREBANK (
        p_afacctno IN VARCHAR2)
RETURN NUMBER
  IS
    l_BALDEFOVD NUMBER(20,2);
    l_cimastcheck_arr txpks_check.ddmastcheck_arrtype;
BEGIN
     l_CIMASTcheck_arr := txpks_check.fn_DDMASTcheck(p_afacctno,'DDMAST','ACCTNO');
     l_BALDEFOVD := l_CIMASTcheck_arr(0).BALANCE;
RETURN l_BALDEFOVD;
EXCEPTION WHEN others THEN
    
    return 0;
END;
/
