SET DEFINE OFF;
CREATE OR REPLACE FUNCTION getavlsewithdraw (p_seacctno in varchar2)
  RETURN number IS

l_AVLSEWITHDRAW NUMBER(20,2);
    l_sewithdrawcheck_arr txpks_check.sewithdrawcheck_arrtype;
     l_semastcheck_arr txpks_check.semastcheck_arrtype;
BEGIN
     --l_sewithdrawcheck_arr := txpks_check.fn_sewithdrawcheck(p_seacctno,'SEWITHDRAW','ACCTNO');
     l_semastcheck_arr := txpks_check.fn_semastcheck(p_seacctno ,'SEMAST','ACCTNO');
     l_AVLSEWITHDRAW := l_semastcheck_arr(0).trade;
     RETURN l_AVLSEWITHDRAW;
exception when others then

    return 0;
END;
/
